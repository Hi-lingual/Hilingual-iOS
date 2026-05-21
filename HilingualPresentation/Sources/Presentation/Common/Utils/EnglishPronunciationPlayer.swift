//
//  EnglishPronunciationPlayer.swift
//  HilingualPresentation
//
//  Created by 성현주 on 5/16/26.
//

@preconcurrency import AVFoundation

@MainActor
public final class EnglishPronunciationPlayer: NSObject {

    // MARK: - Properties

    public static let shared = EnglishPronunciationPlayer()

    private let synthesizer = AVSpeechSynthesizer()
    private var stateChanged: ((Bool) -> Void)?
    private var willSpeakRange: ((NSRange) -> Void)?
    private var didFinishSpeaking: (() -> Void)?
    private var didCancelSpeaking: (() -> Void)?
    private var shouldIgnoreNextCancel = false
    private var preferredVoice: AVSpeechSynthesisVoice?
    private var isPrepared = false
    private var isWarmingUp = false

    public var isSpeaking: Bool {
        synthesizer.isSpeaking
    }

    // MARK: - Init

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: - Public Method

    public func prepare() {
        prepareIfNeeded()
        warmUpSynthesizer()
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

        prepareIfNeeded()

        if isWarmingUp {
            isWarmingUp = false
            shouldIgnoreNextCancel = true
            synthesizer.stopSpeaking(at: .immediate)
        } else if synthesizer.isSpeaking {
            self.stateChanged?(false)
            shouldIgnoreNextCancel = true
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

        stateChanged?(true)
        synthesizer.speak(utterance)
    }

    public func stop() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - Private Method

    private func prepareIfNeeded() {
        guard !isPrepared else { return }
        configureAudioSession()
        preferredVoice = AVSpeechSynthesisVoice(language: "en-US")
        isPrepared = true
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
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(true)
        } catch {
            print("발음 재생 오디오 세션 활성화 실패: \(error.localizedDescription)")
        }
    }

    private func deactivateAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            print("발음 재생 오디오 세션 비활성화 실패: \(error.localizedDescription)")
        }
    }

    private func warmUpSynthesizer() {
        guard !synthesizer.isSpeaking else { return }

        isWarmingUp = true
        activateAudioSession()

        let utterance = AVSpeechUtterance(string: ".")
        utterance.voice = preferredVoice
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 0.01
        synthesizer.speak(utterance)
    }
}

extension EnglishPronunciationPlayer: AVSpeechSynthesizerDelegate {
    nonisolated public func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.willSpeakRange?(characterRange)
        }
    }

    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if self.isWarmingUp {
                self.isWarmingUp = false
                self.deactivateAudioSession()
                return
            }

            self.didFinishSpeaking?()
            self.stateChanged?(false)
            self.deactivateAudioSession()
            self.clearCallbacks()
        }
    }

    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in
            if self.isWarmingUp {
                self.isWarmingUp = false
                self.deactivateAudioSession()
                return
            }

            if self.shouldIgnoreNextCancel {
                self.shouldIgnoreNextCancel = false
                return
            }

            self.didCancelSpeaking?()
            self.stateChanged?(false)
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
