//
//  EnglishPronunciationPlayer.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

import AVFoundation

public final class EnglishPronunciationPlayer: NSObject {

    // MARK: - Properties

    public static let shared = EnglishPronunciationPlayer()

    private let synthesizer = AVSpeechSynthesizer()
    private var currentUtteranceIdentifier: ObjectIdentifier?
    private var stateChanged: ((Bool) -> Void)?
    private var willSpeakRange: ((NSRange) -> Void)?
    private var didFinishSpeaking: (() -> Void)?
    private var didCancelSpeaking: (() -> Void)?
    private var preferredVoice: AVSpeechSynthesisVoice?
    private var isPrepared = false
    private var isSessionActive = false

    public var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    public var isPaused: Bool {
        synthesizer.isPaused
    }

    // MARK: - Init

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Public Method

    public func prepare() {
        guard !isPrepared else { return }
        isPrepared = true
        configureAudioSession()
        preferredVoice = AVSpeechSynthesisVoice(language: "en-US")
        preloadEngine()
    }

    func speak(
        _ text: String,
        stateChanged: ((Bool) -> Void)? = nil,
        willSpeakRange: ((NSRange) -> Void)? = nil,
        didFinish: (() -> Void)? = nil,
        didCancel: (() -> Void)? = nil
    ) {
        let phrase = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !phrase.isEmpty else { return }

        prepare()

        if synthesizer.isSpeaking {
            self.stateChanged?(false)
            clearCallbacks()
            synthesizer.stopSpeaking(at: .immediate)
        }

        self.stateChanged = stateChanged
        self.willSpeakRange = willSpeakRange
        self.didFinishSpeaking = didFinish
        self.didCancelSpeaking = didCancel
        activateAudioSession()

        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = preferredVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0

        currentUtteranceIdentifier = ObjectIdentifier(utterance)
        stateChanged?(true)
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

    // MARK: - Private Method

    private func preloadEngine() {
        activateAudioSession()
        let utterance = AVSpeechUtterance(string: "a")
        utterance.voice = preferredVoice
        synthesizer.write(utterance) { _ in }
    }

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
        } catch {
            print("발음 재생 오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }

    private func activateAudioSession() {
        guard !isSessionActive else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
            isSessionActive = true
        } catch {
            print("발음 재생 오디오 세션 활성화 실패: \(error.localizedDescription)")
        }
    }

    private func deactivateAudioSession() {
        guard isSessionActive else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
            isSessionActive = false
        } catch {
            print("발음 재생 오디오 세션 비활성화 실패: \(error.localizedDescription)")
        }
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
            self.stateChanged?(false)
            self.currentUtteranceIdentifier = nil
            self.deactivateAudioSession()
            self.clearCallbacks()
        }
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        let utteranceID = ObjectIdentifier(utterance)
        DispatchQueue.main.async { [weak self] in
            guard let self, self.currentUtteranceIdentifier == utteranceID else { return }
            self.didCancelSpeaking?()
            self.stateChanged?(false)
            self.currentUtteranceIdentifier = nil
            self.deactivateAudioSession()
            self.clearCallbacks()
        }
    }

    private func clearCallbacks() {
        stateChanged = nil
        willSpeakRange = nil
        didFinishSpeaking = nil
        didCancelSpeaking = nil
    }
}
