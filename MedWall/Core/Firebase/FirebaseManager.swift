// MARK: - Firebase Manager
// File: MedWall/Core/Firebase/FirebaseManager.swift

import Firebase
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    private init() {
        setupAuthStateListener()
    }
    
    private func setupAuthStateListener() {
        auth.addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    // MARK: - Authentication
    func signInAnonymously() async throws {
        let result = try await auth.signInAnonymously()
        Logger.shared.log("Anonymous sign in successful: \(result.user.uid)")
    }
    
    func signIn(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        Logger.shared.log("Sign in successful: \(result.user.uid)")
    }
    
    func createAccount(email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        Logger.shared.log("Account created: \(result.user.uid)")
    }
    
    func signOut() {
        do {
            try auth.signOut()
            Logger.shared.log("Sign out successful")
        } catch {
            Logger.shared.log("Sign out error: \(error)", level: .error)
        }
    }
    
    // MARK: - Firestore Operations
    func fetchMedicalFacts() async throws -> [MedicalFact] {
        let snapshot = try await db.collection("medicalFacts").getDocuments()
        
        return snapshot.documents.compactMap { document in
            do {
                let data = document.data()
                return try self.decodeMedicalFact(from: data)
            } catch {
                Logger.shared.log("Error decoding fact: \(error)", level: .error)
                return nil
            }
        }
    }
    
    func saveMedicalFact(_ fact: MedicalFact) async throws {
        let data = try encodeMedicalFact(fact)
        try await db.collection("medicalFacts").document(fact.id.uuidString).setData(data)
    }
    
    private func decodeMedicalFact(from data: [String: Any]) throws -> MedicalFact {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        return try JSONDecoder().decode(MedicalFact.self, from: jsonData)
    }
    
    private func encodeMedicalFact(_ fact: MedicalFact) throws -> [String: Any] {
        let jsonData = try JSONEncoder().encode(fact)
        let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        return dictionary ?? [:]
    }
}
