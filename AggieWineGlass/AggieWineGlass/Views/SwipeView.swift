//
//  SwipeView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/13/25.
//

import SwiftUI

struct SwipeView: View {
    // MARK: Environment Variables
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo
    
    // MARK: Variables for Opening
    @State private var hasStarted = false
    @State private var showStartButton = false

    // MARK: Variables for Swiping Through Cards
    @State private var currentMiniSet: [Wine] = []
    @State private var swipeResults: [CardView.SwipeDirection] = []
    @State private var selectedProfileSet: [[String]] = []
    @State private var isLoading = false
    @State private var isSwipeReady = false
    
    // MARK: Wine puns (Loading)
    @State private var loadingPun: String = ""
    @State private var showLoadingPun = false
    private let winePuns = [
        "Pouring your next favorite...",
        "Decanting your perfect match...",
        "Swirling through flavor notes...",
        "Uncorking the next wine card...",
        "Letting your next wine breathe...",
        "Fermenting a great pick for you...",
        "Crushing the data... like grapes.",
        "Aged to perfection — almost ready!"
    ]

    @StateObject var viewModel: SwipeViewModel
    
    init(path: Binding<NavigationPath>, preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self._path = path
        self._viewModel = StateObject(wrappedValue:
            SwipeViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            if hasStarted {
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)

                        if showLoadingPun {
                            Text(loadingPun)
                                .font(.custom("Oswald-Regular", size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .transition(.opacity)
                        }
                    }
                    .padding(30)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .navigationBarBackButtonHidden(true)
                } else if isSwipeReady {
                    VStack {
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 28, weight: .bold))
                            Text("Swipe")
                                .font(.custom("Oswald-Regular", size: 28))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 28, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.top, 20)

                         Spacer()

                         SwipeableCardsView(wines: currentMiniSet) { swipedModels in
                             swipeResults = swipedModels.map { $0.swipeDirection }
                             selectedProfileSet = swipedModels.map { $0.selectedProfileSpecifics }
                             isSwipeReady = false
                             onMiniSetSwiped()
                         }
                         .transition(.opacity)
                         .navigationBarBackButtonHidden(true)
                     }
                }
            } else {
                GeometryReader { geometry in
                    ZStack {
                        Text("Swipe RIGHT to Like \nSwipe LEFT to Dislike")
                            .multilineTextAlignment(.center)
                            .font(.custom("Oswald-Regular", size: 32))
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.33)

                        if showStartButton {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    hasStarted = true
                                }
                                startSwipeLoop()
                            }) {
                                Text("Start Swiping")
                                    .font(.headline)
                                    .frame(width: 200, height: 50)
                                    .background(Color.white)
                                    .foregroundColor(Color("PrimaryColor"))
                                    .cornerRadius(10)
                            }
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5), value: showStartButton)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .onAppear {
                    viewModel.setSwipeSets()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showStartButton = true
                        }
                    }
                }
            }
        }
    }

    func startSwipeLoop() {
        loadNextSet()
    }

    func loadNextSet() {
        isLoading = true
        loadingPun = winePuns.randomElement() ?? "Finding your next wine..."
        withAnimation(.easeInOut(duration: 0.3)) {
            showLoadingPun = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var miniSet: [Wine] = []

            if viewModel.redWineSets > 0 {
                miniSet = viewModel.createMiniSet(filterCategory: "Red wine")
                viewModel.redWineSets -= 1
            } else if viewModel.whiteWineSets > 0 {
                miniSet = viewModel.createMiniSet(filterCategory: "White wine")
                viewModel.whiteWineSets -= 1
            } else if viewModel.sparklingWineSets > 0 {
                miniSet = viewModel.createMiniSet(filterCategory: "Sparkling wine")
                viewModel.sparklingWineSets -= 1
            } else if viewModel.dessertWineNum > 0 {
                let wine = viewModel.findCategoryWineRandom(filterCategories: ["Dessert wine"])
                miniSet = [wine]
                viewModel.dessertWineNum -= 1
            } else if viewModel.roseWineNum > 0 {
                let wine = viewModel.findCategoryWineRandom(filterCategories: ["Rosé wine"])
                miniSet = [wine]
                viewModel.roseWineNum -= 1
            } else if viewModel.fortifiedWineNum > 0 {
                let wine = viewModel.findCategoryWineRandom(filterCategories: ["Fortified Wine"])
                miniSet = [wine]
                viewModel.fortifiedWineNum -= 1
            }

            currentMiniSet = miniSet
            swipeResults = []
            isLoading = false
            isSwipeReady = true
            print(miniSet)
        }
    }

    func onMiniSetSwiped() {
        viewModel.miniSetUpdate(
            miniSet: currentMiniSet,
            direction: swipeResults,
            threeProfileSpecifics: selectedProfileSet
        )

        if !setsRemaining() {
            withAnimation {
                path.append(Route.recommendation)
            }
        } else {
            loadNextSet()
        }
    }

    func setsRemaining() -> Bool {
        viewModel.redWineSets > 0 ||
        viewModel.whiteWineSets > 0 ||
        viewModel.sparklingWineSets > 0 ||
        viewModel.dessertWineNum > 0 ||
        viewModel.roseWineNum > 0 ||
        viewModel.fortifiedWineNum > 0
    }
}

struct CardView: View {
    enum SwipeDirection {
        case left, right, none
    }

    struct Model: Identifiable {
        let id = UUID()
        let wine: Wine
        let selectedProfileSpecifics: [String]
        var swipeDirection: SwipeDirection = .none
        
        init(wine: Wine) {
            self.wine = wine
            self.selectedProfileSpecifics = Array(wine.profileSpecifics.shuffled().prefix(3))
        }
    }

    var model: Model
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool

    var body: some View {
        let wine = model.wine
        let selectedProfiles = model.selectedProfileSpecifics

        return VStack(alignment: .leading, spacing: 12) {
            VStack(spacing: 6) {
                Image(wine.category.capitalized)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 10)

                Text("Random \(wine.category.capitalized)")
                    .font(.custom("Oswald-Regular", size: 24))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()

            Text("Attributes")
                .font(.custom("Oswald-Regular", size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 10) {
                WineAttributeSlider(title: "Dry/Sweet", value: wine.drySweet, min: 1, max: 5, color: .white)
                WineAttributeSlider(title: "Tannin", value: wine.tannin, min: 1, max: 5, color: .white)
                WineAttributeSlider(title: "Soft/Acidic", value: wine.softAcidic, min: 1, max: 5, color: .white)
                WineAttributeSlider(title: "Light/Bold", value: wine.lightBold, min: 1, max: 5, color: .white)
                WineAttributeSlider(title: "Fizziness", value: wine.fizziness, min: 0, max: 5, color: .white)
            }
            
            Spacer()

            VStack(alignment: .center, spacing: 10) {
                Text("Profile Highlights")
                    .font(.custom("Oswald-Regular", size: 20))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 16) {
                    ForEach(selectedProfiles, id: \.self) { profile in
                        VStack(spacing: 6) {
                            Image(profile)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)

                            Text(profile.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.footnote)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 8)


            Spacer()
        }
        .padding()
        .frame(width: size.width * 0.8, height: size.height * 0.8)
        .background(Color("PrimaryColor"))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 3)
        )
        .shadow(
            color: isTopCard
                ? getShadowColor()
                : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear),
            radius: 20, x: 0, y: 6
        )
        .foregroundColor(.white)
        .padding()
    }

    private func getShadowColor() -> Color {
        if dragOffset.width > 0 {
            return Color.green.opacity(0.8)
        } else if dragOffset.width < 0 {
            return Color.red.opacity(0.8)
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}

extension CardView.Model: Equatable {
    static func == (lhs: CardView.Model, rhs: CardView.Model) -> Bool {
        lhs.id == rhs.id
    }
}

struct SwipeableCardsView: View {
    class Model: ObservableObject {
        @Published var unswipedCards: [CardView.Model]
        @Published var swipedCards: [CardView.Model]

        init(cards: [CardView.Model]) {
            self.unswipedCards = cards
            self.swipedCards = []
        }

        func removeTopCard() {
            if !unswipedCards.isEmpty {
                let card = unswipedCards.removeFirst()
                swipedCards.append(card)
            }
        }

        func updateTopCardSwipeDirection(_ direction: CardView.SwipeDirection) {
            if !unswipedCards.isEmpty {
                unswipedCards[0].swipeDirection = direction
            }
        }
    }

    @StateObject private var model: Model
    @State private var dragState = CGSize.zero
    @State private var cardRotation: Double = 0

    private let swipeThreshold: CGFloat = 100.0
    private let rotationFactor: Double = 35.0

    var action: ([CardView.Model]) -> Void

    init(wines: [Wine], action: @escaping ([CardView.Model]) -> Void) {
        let cardModels = wines.map { CardView.Model(wine: $0) }
        _model = StateObject(wrappedValue: Model(cards: cardModels))
        self.action = action
    }

    var body: some View {
        GeometryReader { geometry in
            if model.unswipedCards.isEmpty {
                Color.clear
                    .onAppear {
                        action(model.swipedCards)
                    }
            } else {
                ZStack {
                    Color("PrimaryColor").ignoresSafeArea()

                    ForEach(model.unswipedCards.reversed()) { card in
                        let isTop = card == model.unswipedCards.first
                        let isSecond = card == model.unswipedCards.dropFirst().first

                        CardView(
                            model: card,
                            size: geometry.size,
                            dragOffset: dragState,
                            isTopCard: isTop,
                            isSecondCard: isSecond
                        )
                        .offset(x: isTop ? dragState.width : 0)
                        .rotationEffect(.degrees(isTop ? Double(dragState.width) / rotationFactor : 0))
                        .gesture(
                            isTop ?
                            DragGesture()
                                .onChanged { gesture in
                                    dragState = gesture.translation
                                    cardRotation = Double(gesture.translation.width) / rotationFactor
                                }
                                .onEnded { _ in
                                    if abs(dragState.width) > swipeThreshold {
                                        let swipeDirection: CardView.SwipeDirection = dragState.width > 0 ? .right : .left
                                        model.updateTopCardSwipeDirection(swipeDirection)

                                        withAnimation(.easeOut(duration: 0.5)) {
                                            dragState.width = dragState.width > 0 ? 1000 : -1000
                                        }

                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            model.removeTopCard()
                                            dragState = .zero
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            dragState = .zero
                                            cardRotation = 0
                                        }
                                    }
                                }
                            : nil
                        )
                        .animation(.easeInOut, value: dragState)
                    }
                }
            }
        }
    }
}

struct WineAttributeSlider: View {
    let title: String
    let value: Double
    let min: Double
    let max: Double
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 100, alignment: .leading)
                .font(.subheadline)
                .foregroundColor(.white)

            GeometryReader { geometry in
                let clampedValue = Swift.min(Swift.max(value, min), max)
                let percent = (clampedValue - min) / (max - min)

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 6)

                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percent), height: 6)
                }
            }
            .frame(height: 10)
            .padding(.horizontal, 8)

            Text(String(format: "%.1f", value))
                .frame(width: 35, alignment: .trailing)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
