//
//  TicTacToeViewController.swift
//  MiniApps
//
//  Created by Валентина Попова on 07.09.2024.
//

import UIKit

final class TicTacToeViewController: UIViewController {
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var symbolSwitch: UISegmentedControl = {
        let control = UISegmentedControl(items: ["X", "O"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemBlue
        control.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 20)], for: .normal)
        control.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 20)], for: .selected)
        control.addTarget(self, action: #selector(symbolSwitchChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: config), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(restartGameTapped), for: .touchUpInside)
        return button
    }()
    
    private var gameButtons: [UIButton] = []
    
    private enum Player {
        case x
        case o
    }
    
    private var currentPlayer: Player = .x
    private var gameState = Array(repeating: "", count: 9)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        resetGame()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(statusLabel)
        view.addSubview(symbolSwitch)
        view.addSubview(restartButton)
        
        let gridContainer = UIView()
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        let buttonSize: CGFloat = (view.frame.width - 60) / 3
        for i in 0..<9 {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 56, weight: .bold)
            button.backgroundColor = .systemGray6
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.addTarget(self, action: #selector(gameButtonTapped(_:)), for: .touchUpInside)
            gridContainer.addSubview(button)
            gameButtons.append(button)
            
            let row = i / 3
            let col = i % 3
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: gridContainer.topAnchor, constant: CGFloat(row) * (buttonSize + 10)),
                button.leadingAnchor.constraint(equalTo: gridContainer.leadingAnchor, constant: CGFloat(col) * (buttonSize + 10)),
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
        }
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: restartButton.centerYAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gridContainer.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            gridContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gridContainer.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            gridContainer.heightAnchor.constraint(equalToConstant: view.frame.width - 40),
            
            symbolSwitch.topAnchor.constraint(equalTo: gridContainer.bottomAnchor, constant: 40),
            symbolSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            restartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            restartButton.widthAnchor.constraint(equalToConstant: 25),
            restartButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func symbolSwitchChanged(_ sender: UISegmentedControl) {
        currentPlayer = sender.selectedSegmentIndex == 0 ? .x : .o
        updateSegmentedControlColors()
        resetGame()
    }

    private func updateSegmentedControlColors() {
        if symbolSwitch.selectedSegmentIndex == 0 {
            symbolSwitch.selectedSegmentTintColor = .systemBlue
        } else {
            symbolSwitch.selectedSegmentTintColor = .systemTeal
        }
    }
    
    @objc private func gameButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        if gameState[index] == "" {
            gameState[index] = currentPlayer == .x ? "X" : "O"
            sender.setTitle(gameState[index], for: .normal)
            sender.setTitleColor(currentPlayer == .x ? .systemBlue : .systemTeal, for: .normal)
            
            if let winningCombination = checkForWin(player: currentPlayer == .x ? "X" : "O") {
                statusLabel.text = "\(currentPlayer == .x ? "X" : "O") выиграл!"
                highlightWinningCombination(winningCombination)
                disableButtons()
            } else if !gameState.contains("") {
                statusLabel.text = "Ничья!"
            } else {
                currentPlayer = currentPlayer == .x ? .o : .x
                if currentPlayer == .o {
                    computerMove()
                }
            }
        }
    }
    
    private func highlightWinningCombination(_ combination: [Int]) {
        for index in combination {
            let button = gameButtons[index]
            button.backgroundColor = UIColor(red: 0.88, green: 1.0, blue: 0.88, alpha: 1.0) // Очень светло-зеленый цвет
        }
    }
    
    private func computerMove() {
        var bestMove: Int? = nil
        
        for i in 0..<gameState.count {
            if gameState[i] == "" {
                gameState[i] = "O"
                if checkForWin(player: "O") != nil {
                    bestMove = i
                    break
                } else {
                    gameState[i] = ""
                }
            }
        }
        
        if bestMove == nil {
            for i in 0..<gameState.count {
                if gameState[i] == "" {
                    gameState[i] = "X"
                    if checkForWin(player: "X") != nil {
                        bestMove = i
                        break
                    } else {
                        gameState[i] = ""
                    }
                }
            }
        }
        
        if bestMove == nil {
            var availableMoves: [Int] = []
            for i in 0..<gameState.count {
                if gameState[i] == "" {
                    availableMoves.append(i)
                }
            }
            bestMove = availableMoves.randomElement()
        }
        
        if let move = bestMove {
            gameState[move] = "O"
            let button = gameButtons[move]
            button.setTitle("O", for: .normal)
            button.setTitleColor(.systemTeal, for: .normal)
            
            if let winningCombination = checkForWin(player: "O") {
                statusLabel.text = "O выиграл!"
                highlightWinningCombination(winningCombination)
                disableButtons()
            } else if !gameState.contains("") {
                statusLabel.text = "Ничья!"
            } else {
                currentPlayer = .x
                statusLabel.text = "Твой ход (X)"
            }
        }
    }
    
    @objc private func restartGameTapped() {
        resetGame()
    }
    
    private func resetGame() {
        currentPlayer = symbolSwitch.selectedSegmentIndex == 0 ? .x : .o
        gameState = Array(repeating: "", count: 9)
        statusLabel.text = "Твой ход (\(currentPlayer == .x ? "X" : "O"))"
        for button in gameButtons {
            button.setTitle("", for: .normal)
            button.isEnabled = true
            button.backgroundColor = .systemGray6
        }
        if currentPlayer == .o {
            computerMove()
        }
    }
    
    private func disableButtons() {
        for button in gameButtons {
            button.isEnabled = false
        }
    }
    
    private func checkForWin(player: String) -> [Int]? {
        let winningCombinations = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        for combination in winningCombinations {
            if gameState[combination[0]] == player &&
                gameState[combination[1]] == player &&
                gameState[combination[2]] == player {
                return combination
            }
        }
        return nil
    }
}
