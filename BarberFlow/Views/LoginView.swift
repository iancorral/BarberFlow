import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @FocusState private var focus: Field?

    enum Field { case email, password }

    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && password.count >= 4
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    // Header
                    VStack(spacing: 16) {
                        Image("ph_scissors")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 67, height: 67)
                            .foregroundStyle(Color.brandWood)

                        Text("BARBERÍA")
                            .font(BrandFont.display(32, weight: .bold))
                            .foregroundStyle(Color.brandTextPrimary)
                            .kerning(6)

                        Text("Reserva tu próxima cita")
                            .font(BrandFont.sans(14))
                            .foregroundStyle(Color.brandTextSecondary)
                    }
                    .padding(.top, 72)
                    .padding(.bottom, 52)

                    // Form
                    VStack(spacing: 20) {

                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("Correo electrónico")
                            TextField("", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .focused($focus, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focus = .password }
                                .font(BrandFont.sans(15))
                                .foregroundStyle(Color.brandTextPrimary)
                                .padding(14)
                                .background(Color.brandSurfaceAlt)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            fieldLabel("Contraseña")
                            HStack {
                                Group {
                                    if showPassword {
                                        TextField("", text: $password)
                                    } else {
                                        SecureField("", text: $password)
                                    }
                                }
                                .focused($focus, equals: .password)
                                .submitLabel(.done)
                                .onSubmit {
                                    if canSubmit {
                                        Task { await authVM.login(email: email, password: password) }
                                    }
                                }
                                .font(BrandFont.sans(15))
                                .foregroundStyle(Color.brandTextPrimary)

                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundStyle(Color.brandTextTertiary)
                                        .font(.system(size: 16))
                                }
                            }
                            .padding(14)
                            .background(Color.brandSurfaceAlt)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        // Error
                        if let error = authVM.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle")
                                    .font(.system(size: 14))
                                Text(error)
                                    .font(BrandFont.sans(13))
                            }
                            .foregroundStyle(Color.brandWine)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Botón
                        Button {
                            Task { await authVM.login(email: email, password: password) }
                        } label: {
                            if authVM.isLoading {
                                ProgressView()
                                    .tint(Color.brandBackground)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            } else {
                                Text("Iniciar sesión")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle(isEnabled: canSubmit && !authVM.isLoading))
                        .disabled(!canSubmit || authVM.isLoading)
                        .padding(.top, 4)
                    }
                    .padding(24)
                    .cardStyle()
                    .padding(.horizontal, 24)

                    Spacer(minLength: 48)
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: authVM.errorMessage)
    }

    @ViewBuilder
    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(BrandFont.sans(12, weight: .medium))
            .foregroundStyle(Color.brandTextSecondary)
            .kerning(0.5)
            .textCase(.uppercase)
    }
}
