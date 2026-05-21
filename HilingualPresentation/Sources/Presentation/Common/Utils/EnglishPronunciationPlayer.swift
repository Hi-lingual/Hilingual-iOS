//
//  EnglishPronunciationPlayer.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

import AVFoundation

public final class EnglishPronunciationPlayer: NSObject {

    public static let shared = EnglishPronunciationPlayer()

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtteranceIdentifier: ObjectIdentifier?
    private var willSpeakRange: ((NSRange) -> Void)?
    private var didFinishSpeaking: (() -> Void)?
    private var didCancelSpeaking: (() -> Void)?
    private var preferredVoice: AVSpeechSynthesisVoice?
    private var isSessionActive = false

    public var isSpeaking: Bool { synthesizer.isSpeaking }
    public var isPaused: Bool { synthesizer.isPaused }

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Public Method

    public func prepare() {
        guard preferredVoice == nil else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        } catch {
            print("오디오 세션 설정 실패: \(error.localizedDescription)")
        }
        preferredVoice = AVSpeechSynthesisVoice(language: "en-US")
        preloadEngine()
    }

    public func speak(
        _ text: String,
        willSpeakRange: ((NSRange) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        didCancel: (() -> Void)? = nil
    ) {
        let phrase = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phrase.isEmpty else { return }

        prepare()

        if synthesizer.isSpeaking {
            completeUtterance()
            synthesizer.stopSpeaking(at: .immediate)
        }

        self.willSpeakRange = willSpeakRange
        self.didFinishSpeaking = didFinish
        self.didCancelSpeaking = didCancel
        activateAudioSession()

        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = preferredVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9

        currentUtteranceIdentifier = ObjectIdentifier(utterance)
        synthesizer.speak(utterance)
    }

    public func pause() {
        guard synthesizer.isSpeaking, !synthesizer.isPaused else { return }
        synthesizer.pauseSpeaking(at: .immediate)
    }

    public func resume() {
        guard synthesizer.isPaused else { return }
        synthesizer.continueSpeaking()
    }

    public func stop() {
        guard synthesizer.isSpeaking else { return }
        currentUtteranceIdentifier = nil
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Private

    private func preloadEngine() {
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: "a")
        utterance.voice = preferredVoice
        synthesizer.write(utterance) { _ in }
    }

    private func activateAudioSession() {
        guard !isSessionActive else { return }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            isSessionActive = true
        } catch {
            print("오디오 세션 활성화 실패: \(error.localizedDescription)")
        }
    }

    private func deactivateAudioSession() {
        guard isSessionActive else { return }
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
            isSessionActive = false
        } catch {
            print("오디오 세션 비활성화 실패: \(error.localizedDescription)")
        }
    }

    private func completeUtterance() {
        currentUtteranceIdentifier = nil
        deactivateAudioSession()
        willSpeakRange = nil
        didFinishSpeaking = nil
        didCancelSpeaking = nil
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension EnglishPronunciationPlayer: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        let utteranceID = ObjectIdentifier(utterance)
        DispatchQueue.main.async { [weak self] in
            guard let self, self.currentUtteranceIdentifier == utteranceID else { return }
            self.willSpeakRange?(characterRange)
        }
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        let utteranceID = ObjectIdentifier(utterance)
        DispatchQueue.main.async { [weak self] in
            guard let self, self.currentUtteranceIdentifier == utteranceID else { return }
            self.didFinishSpeaking?()
            self.completeUtterance()
        }
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let utteranceID = ObjectIdentifier(utterance)
        DispatchQueue.main.async { [weak self] in
            guard let self, self.currentUtteranceIdentifier == utteranceID else { return }
            self.didCancelSpeaking?()
            self.completeUtterance()
        }
    }
}
