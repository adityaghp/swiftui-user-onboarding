//
//  OnboardingView.swift
//  UserOnboarding
//
//  Created by Aditya Ghorpade on 27/11/23.
//

import SwiftUI

struct OnboardingView: View {
    
    // Onboarding States:
    /*
     0 - Welcome screen
     1 - Add name
     2 - Add age
     3 - Add gender
     */
    @State var onboardingState: Int = 0
    let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading))
    
    //onboarding inputs
    @State var name: String = ""
    @State var age: Double = 18
    @State var gender: String = ""
    
    //for alerts
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    //for app storage
    @AppStorage("name") var currentUserName: String?
    @AppStorage("age") var currentUserAge: Int?
    @AppStorage("gender") var currentUserGender: String?
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    
    var body: some View {
        ZStack {
            //content
            ZStack {
                switch onboardingState {
                case 0:
                    welcomeSection
                        .transition(transition)
                case 1:
                    addNameSection
                        .transition(transition)
                case 2:
                    addAgeSection
                        .transition(transition)
                default:
                    addGenderSection
                        .transition(transition)
                }
            }
            //buttons
            VStack {
                Spacer()
                bottomButton
            }
            .padding(30)
        }
        .alert(alertTitle, isPresented: $showAlert) {}
    }
}

#Preview {
    OnboardingView()
        .background(Color.purple)
}


//MARK: COMPONENTS
extension OnboardingView {
    
    private var bottomButton: some View {
        Text(onboardingState == 0 ? "SIGN UP" : onboardingState == 3 ? "FINISH" : "NEXT" )
            .font(.headline)
            .foregroundStyle(Color.purple)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(
                Color.white
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .onTapGesture {
                handleButtonPressed()
            }
            .animation(nil, value: onboardingState)
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundStyle(Color.white)
            
            Text("Find your match!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
                .overlay(
                    Capsule(style: .continuous)
                        .frame(height: 3)
                        .offset(y: 5)
                        .foregroundColor(.white)
                    , alignment: .bottom
                )
            
            Text("This is the #1 app for finding your match online! This is sampele SwiftUI project app for practicing using AppStorage and other SwiftUI technique.")
                .fontWeight(.medium)
                .foregroundStyle(Color.white)
            
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(30)
    }
    
    private var addNameSection: some View {
        VStack(spacing: 40) {
            Spacer()
            Text("What's your name?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
            
            TextField("Your name here...", text: $name)
                .font(.headline)
                .frame(height: 55)
                .padding(.horizontal)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addAgeSection: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("What's your age?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
            
            Text(String(format: "%.0f", age))
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
            
            Slider(
                value: $age,
                in: 18...100,
                step: 1.0
            )
            .tint(Color.white)
            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addGenderSection: some View {
        VStack {
            Spacer()
            Text("What's your gender?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.white)
            
            Picker(selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
                Text("Non-binary").tag("Non-binary")
                Text("Prefer not to say").tag("Prefer not to say")
            } label: {
                Text("Select your gender")
            }
            .foregroundStyle(Color.white)
            .fontWeight(.bold)
            .pickerStyle(WheelPickerStyle())

            
            Spacer()
            Spacer()
        }
        .padding(30)
    }
}

//MARK: FUNCTIONS

extension OnboardingView {
    func handleButtonPressed() {
        
        //CHECK INPUTS
        switch onboardingState {
        case 1:
            guard name.count != 0 else {
                displayAlert(title: "Please enter your name!")
                return
            }
        case 3:
            guard gender.count > 1 else {
                displayAlert(title: "Please Select your gender!")
                return
            }
         default:
            break
        }
        
        if onboardingState == 3 {
            signIn()
        } else {
            withAnimation(.default) {
                onboardingState += 1
            }
        }
    }
    
    func signIn() {
        currentUserName = name
        currentUserAge = Int(age)
        currentUserGender = gender
        withAnimation(.default) {
            currentUserSignedIn = true
        }
    }
    
    func displayAlert(title: String) {
        alertTitle = title
        showAlert.toggle()
    }
 }
