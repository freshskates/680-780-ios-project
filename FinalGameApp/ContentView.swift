import SwiftUI

// TIC TAC TOE - Made by Robert Cacho
// Attribution - Jared Davidson

enum SquareStatus{
    case empty
    case home
    case visitor
}

class Square : ObservableObject{
    @Published var squareStatus : SquareStatus
    
    init(status : SquareStatus){
        self.squareStatus = status
    }
}

class TicTacToeModel : ObservableObject{
    @Published var squares = [Square]()
    
    init(){
        for _ in 0...8{
            squares.append(Square(status: .empty))
        }
    }
    
    func resetGame(){
        for i in 0...8{
            squares[i].squareStatus = .empty
        }
    }
    
    var gameOver : (SquareStatus, Bool){
        get {
            if isWinner != .empty{
                return (isWinner, true)
            }else{
                for i in 0...8{
                    if squares[i].squareStatus == .empty{
                        return(.empty, false)
                    }
                }
                return(.empty, true)
            }
        }
    }
    
    private var isWinner: SquareStatus {
        get {
            if let check = self.checkIndexes([0, 1, 2]){
                return check
            }else if let check = self.checkIndexes([3, 4, 5]){
                return check
            }else if let check = self.checkIndexes([6, 7, 8]){
                return check
            }else if let check = self.checkIndexes([0, 3, 6]){
                return check
            }else if let check = self.checkIndexes([1, 4, 7]){
                return check
            }else if let check = self.checkIndexes([2, 5, 8]){
                return check
            }else if let check = self.checkIndexes([0, 4, 8]){
                return check
            }else if let check = self.checkIndexes([2, 4, 6]){
                return check
            }
            return .empty
        }
    }
    
    private func checkIndexes(_ indexes : [Int]) -> SquareStatus?{
        var homeCounter : Int = 0
        var visitorCounter : Int = 0
        for index in indexes{
            let square = squares[index]
            if square.squareStatus == .home{
                homeCounter += 1
            }else if square.squareStatus == .visitor{
                visitorCounter += 1
            }
        }
        if homeCounter == 3{
            return .home
        }else if visitorCounter == 3{
            return .visitor
        }
        return nil
    }
    
    private func moveAI(){
        var index = Int.random(in: 0...8)
        while makeMove(index: index, player: .visitor) == false && gameOver.1 == false{
            index = Int.random(in: 0...8)
        }
    }
    
    func makeMove(index: Int, player: SquareStatus) -> Bool{
        if squares[index].squareStatus == .empty{
            squares[index].squareStatus = player
            if player == .home{
                moveAI()
            }
            return true
        }
        return false
    }
}

struct SquareView : View {
    @ObservedObject var dataSource : Square
    var action: () -> Void
    var body: some View{
        Button(action: {
            self.action()
        }, label: {
            Text(self.dataSource.squareStatus == .home ? "X" : self.dataSource.squareStatus == .visitor ? "O" : " " )
                .frame(width: 100, height: 100)
                .font(.largeTitle)
                
                .foregroundColor(.black)
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .padding(4)
        }).frame(width: 100, height: 100)
    }
}

struct TicTacToeView: View {
    @StateObject var tttModel = TicTacToeModel()
    @State var gameOver : Bool = false
    
    func buttonAction(_ index : Int){
        _ = self.tttModel.makeMove(index: index, player: .home)
        self.gameOver = self.tttModel.gameOver.1
    }
    
    var body: some View {
        VStack{
            ForEach(0..<3, content: {
                row in
                HStack{
                    ForEach(0..<3, content: {
                        column in
                        let index = row * 3 + column
                        SquareView(dataSource: tttModel.squares[index], action: {self.buttonAction(index)})
                    })
                }
            })
        }.alert(isPresented: self.$gameOver, content: {
            Alert(title: Text("Game Over"), message: Text(self.tttModel.gameOver.0 != .empty ? self.tttModel.gameOver.0 == .home ? "You Win" : "Computer Wins" : "Cat's Game"), dismissButton: Alert.Button.destructive(Text("OK"), action: {
                self.tttModel.resetGame()
            }))
        })
    }
}



// ROCK PAPER SCISSORS - Made by Ana Nytochka
// Attribution - Citrus Apps

struct RockPaperScissorsView: View {
    
    let options = ["Rock", "Paper", "Scissors"]
    
    @State private var computer = Int.random(in: 0..<3)
    @State private var win = Bool.random()
    @State private var playerScore = 0
    @State private var currentStep = 1
    @State private var showingAlert = false
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25){
                Text("Steps: \(currentStep)/10")
                    .font(.title)
                Text("Player score: \(playerScore)")
                    .font(.title)
                Text(options[computer])
                    .font(.largeTitle)
                Text(win ? "Win" : "Lose")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                HStack(spacing: 8){
                    ForEach(0 ..< 3){ optionID in
                        Button(action: {
                            if self.currentStep == 10 {
                                self.currentStep = 0
                                self.playerScore = 0
                                self.showingAlert = true
                            }else{
                                self.calculateScore(withMove: optionID)
                            }
                        }){
                            Text("\(self.options[optionID])")
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, height: 100, alignment: .center)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        
                        .alert(isPresented: self.$showingAlert){
                            Alert(title: Text("Game Over"), message: Text("Final Score: \(playerScore)"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
            }
            .foregroundColor(.black)
        }
    }
    func calculateScore(withMove currentPlayerChoice: Int){
        if computer == currentPlayerChoice{
            playerScore += 0
        }else if win{
            switch computer{
            case 0:
                if currentPlayerChoice == 1{
                    playerScore += 1
                }
            case 1:
                if currentPlayerChoice == 2{
                    playerScore += 1
                }
            case 2:
                if currentPlayerChoice == 0{
                    playerScore += 1
                }
            default:
                break
            }
        }else{
            switch computer{
            case 0:
                if currentPlayerChoice == 2{
                    playerScore += 1
                }
            case 1:
                if currentPlayerChoice == 0{
                    playerScore += 1
                }
            case 2:
                if currentPlayerChoice == 1{
                    playerScore += 1
                }
            default:
                break
            }
        }
        computer = Int.random(in: 0 ..< 3)
        win = Bool.random()
        currentStep += 1
    }
}


struct TicTacToe: View {
    var body: some View {
        NavigationView {
            TicTacToeView()
            .navigationTitle("tictactoe")
        }
    }
}

struct RockPaperScissors: View {
    var body: some View {
        NavigationView {
            RockPaperScissorsView()
            .navigationTitle("rock paper scissors")
        }
    }
}


struct HomeView: View {
    var body: some View {

        NavigationView {
            ZStack {
                Color.white
                
                VStack{
                    Text("Game Library")
                        .font(.system(.title, design: .rounded))
                        .foregroundColor(.black)
                        .fontWeight(.black)
                    
                    HStack {
                        VStack {
                            NavigationLink(destination: TicTacToe(), label: {
                                
                                    
                                    
                                    VStack{
                                        Color.blue
                                    }
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(20)
                                
                            })
                            .frame(width: 200, height: 200)
                            .background(.blue)
                            .cornerRadius(20)
                        
                            Text("Tic Tac Toe")
                            .foregroundColor(.black)
                            .fontWeight(.black)
                        }
                        
                        VStack {
                            NavigationLink(destination: RockPaperScissors(), label: {
                                VStack{
                                    Color.pink
                                }
                                .frame(width: 200, height: 200)
                                .cornerRadius(20)
                            })
                            
                            Text("Rock Paper Scissors")
                                .foregroundColor(.black)
                                .fontWeight(.black)
                        }
                        
                    }
                    
                    HStack {
                        VStack {
                            
                        
                        VStack{
                            Color.green
                        }
                        .frame(width: 400, height: 200)
                        .cornerRadius(20)
                         
                        Text("Comming Soon")
                                .foregroundColor(.black)
                                .fontWeight(.black)
                        }
                    }
                }
                .offset(y: -60)
            }
            .navigationTitle("Home")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
