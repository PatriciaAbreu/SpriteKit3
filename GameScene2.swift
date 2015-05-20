//
//  GameScene2.swift
//  Teste1_SpriteKit
//
//  Created by Patricia de Abreu on 18/05/15.
//  Copyright (c) 2015 Patricia de Abreu. All rights reserved.
//

import SpriteKit
import AVFoundation

//implementar o delegate
class GameScene2: SKScene, SKPhysicsContactDelegate {
    
    //verifica se a scene existe
    var existe:Bool = false

    //respostas
    var num1:Int = 0
    var num2:Int = 0
    //    Adicionando um Sprite
    // 1 - declara um sprite (player) privado e constante
    let player = SKSpriteNode(imageNamed: "fadinha")
    let superDente1 = SKSpriteNode(imageNamed: "nuvem")
    let superDente2 = SKSpriteNode(imageNamed: "nuvem")
    let superDente3 = SKSpriteNode(imageNamed: "nuvem")
    let dentePodre = SKSpriteNode(imageNamed: "nuvem")
    let dente = SKSpriteNode(imageNamed: "dente")
    
    //Declaração labels das respostas e pergunta
    var labelResposta1 = SKLabelNode(fontNamed: "resposta1")
    var labelResposta2 = SKLabelNode(fontNamed: "resposta2")
    var labelResposta3 = SKLabelNode(fontNamed: "resposta3")
    var labelPergunta = SKLabelNode(fontNamed: "pergunta")
    
    var superDenteDestroyed = 0
    var dinheiroDestroyed = 0
    var dentePodreDestroyed = 0
    var score = 0
    var background: SKSpriteNode!
    let labelScore = SKLabelNode(fontNamed: "score")
    
    var posicao: Int = 0
    var cont: Int = 0
    override func didMoveToView(view: SKView) {
        println("didMoveToView - Inicio")
        
        if !existe{
            montarScene()
            cont++
            println("didMoveToView - Nova tela criada \(cont)")
        }
        
        // random para escolher operação
        var operacao = random(0, 3)
        
        // random para escolher nuvem
        posicao = random(0, 2)
        var num1 = obterNumeros()
        var num2 = obterNumeros()
        var resposta: Int = 0
        
        
        // +
        if operacao == 0 {
            if (posicao == 0){
                resposta = obterOperacoes("+")
                labelResposta1.text = "\(resposta)"
                labelResposta2.text = "\(num1)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 1){
                resposta = obterOperacoes("+")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(resposta)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 2){
                resposta = obterOperacoes("+")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(num2)"
                labelResposta3.text = "\(resposta)"
                
            }
            
            println("\(resposta) e \(num1) e \(num2) e \(posicao)")
        }else if operacao == 1 {
            if (posicao == 0){
                resposta = obterOperacoes("-")
                labelResposta1.text = "\(resposta)"
                labelResposta2.text = "\(num1)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 1){
                resposta = obterOperacoes("-")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(resposta)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 2){
                resposta = obterOperacoes("-")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(num2)"
                labelResposta3.text = "\(resposta)"
                
            }
            
            println("\(resposta) e \(num1) e \(num2) e \(posicao)")
        }else if operacao == 2 {
            if (posicao == 0){
                resposta = obterOperacoes("*")
                labelResposta1.text = "\(resposta)"
                labelResposta2.text = "\(num1)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 1){
                resposta = obterOperacoes("*")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(resposta)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 2){
                resposta = obterOperacoes("*")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(num2)"
                labelResposta3.text = "\(resposta)"
                
            }
            
            println("\(resposta) e \(num1) e \(num2) e \(posicao)")
        }else if operacao == 3 {
            if (posicao == 0){
                resposta = obterOperacoes("/")
                labelResposta1.text = "\(resposta)"
                labelResposta2.text = "\(num1)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 1){
                resposta = obterOperacoes("/")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(resposta)"
                labelResposta3.text = "\(num2)"
                
            }else if(posicao == 2){
                resposta = obterOperacoes("/")
                labelResposta1.text = "\(num1)"
                labelResposta2.text = "\(num2)"
                labelResposta3.text = "\(resposta)"
                
            }
            
            println("\(resposta) e \(num1) e \(num2) e \(posicao)")
        }
        
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    func animarMoeda(moeda: SKSpriteNode, imagens: Array<SKTexture>){
        moeda.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(imagens, timePerFrame: 0.01, resize: false, restore: true)), withKey: "animarMoeda")
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // musica do app
        runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        
        // 1 - pega o primeiro toque na tela
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        // 2 - seta a posicao inicial da moeda
        var numImages = 10;
        var moedaAnimatedAtlas: SKTextureAtlas = SKTextureAtlas(named: "moeda")
        var imagensMoedaGirando: Array<SKTexture> = []
        
        for ( var i=0; i < numImages; i++){
            var textureName: String = String(format: "moeda%d", arguments: [i])
            var temp: SKTexture = moedaAnimatedAtlas.textureNamed(textureName)
            imagensMoedaGirando.append(temp)
        }
        
        var temp: SKTexture = imagensMoedaGirando[0]
        let moeda = SKSpriteNode(texture: temp)
        
        
        if posicao == 0 {
            if superDente1.containsPoint(touchLocation) {
//                dentePodre.position = CGPoint(x: size.width * 0.8, y: size.width * 0.1)
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "PARABÉNS!!! Você acertou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                
//                moeda.position = superDente1.position
//                moeda.xScale = 1
//                moeda.yScale = 1
//                animarMoeda(moeda, imagens: imagensMoedaGirando)
//                
//                let actionMovie = SKAction.moveTo(dentePodre.position, duration: 0.5)
//                moeda.runAction(SKAction.sequence([actionMovie]))
//                addChild(moeda)
//                
//                moeda.physicsBody = SKPhysicsBody(circleOfRadius: moeda.size.width/2)
//                moeda.physicsBody?.dynamic = true
//                moeda.physicsBody?.categoryBitMask = PhysicsCategory.Moeda
//                moeda.physicsBody?.contactTestBitMask = PhysicsCategory.DentePodre
//                moeda.physicsBody?.usesPreciseCollisionDetection = true
            }else if superDente2.containsPoint(touchLocation) {
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente2.position
                superDente2.removeFromParent()
                addChild(dente)
            }else if superDente3.containsPoint(touchLocation) {
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente3.position
                superDente3.removeFromParent()
                addChild(dente)
            }
        }else if posicao == 1 {
            if superDente1.containsPoint(touchLocation) {
                
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente1.position
                superDente1.removeFromParent()
                addChild(dente)
            }else if superDente2.containsPoint(touchLocation) {
//                dentePodre.position = CGPoint(x: size.width * 0.2, y: size.width * 0.1)
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "PARABÉNS!!! Você acertou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
//                moeda.position = superDente2.position
//                moeda.xScale = 1
//                moeda.yScale = 1
//                animarMoeda(moeda, imagens: imagensMoedaGirando)
//                
//                let actionMovie = SKAction.moveTo(dentePodre.position, duration: 0.5)
//                moeda.runAction(SKAction.sequence([actionMovie]))
//                addChild(moeda)
//                
//                moeda.physicsBody = SKPhysicsBody(circleOfRadius: moeda.size.width/2)
//                moeda.physicsBody?.dynamic = true
//                moeda.physicsBody?.categoryBitMask = PhysicsCategory.Moeda
//                moeda.physicsBody?.contactTestBitMask = PhysicsCategory.DentePodre
//                moeda.physicsBody?.usesPreciseCollisionDetection = true
            }else if superDente3.containsPoint(touchLocation) {
                
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente3.position
                superDente3.removeFromParent()
                addChild(dente)
            }
        }else if posicao == 2 {
            if superDente1.containsPoint(touchLocation) {
                
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
            
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente1.position
                superDente1.removeFromParent()
                addChild(dente)
            }else if superDente2.containsPoint(touchLocation) {
                
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "Que pena...Você errou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
                dente.position = superDente2.position
                superDente2.removeFromParent()
                addChild(dente)
            }else if posicao == 3 {
//                dentePodre.position = CGPoint(x: size.width * 0.5, y: size.width * 0.1)
                
                var labelWin = SKLabelNode(fontNamed: "Win")
                var labelWinCarregando = SKLabelNode(fontNamed: "Carregando")
                
                labelWin.position = CGPoint(x: 500, y: 300)
                labelWinCarregando.position = CGPoint(x: 500, y: 700)
                
                labelWin.fontSize = 80
                labelWinCarregando.fontSize = 70
                
                labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
                labelWinCarregando.fontColor = SKColor.blackColor()
                
                labelWin.text = "PARABÉNS!!! Você acertou! "
                labelWinCarregando.text = "Carregando próximo nível!"
                
                addChild(labelWin)
                addChild(labelWinCarregando)
                
//                moeda.position = superDente3.position
//                moeda.xScale = 1
//                moeda.yScale = 1
//                animarMoeda(moeda, imagens: imagensMoedaGirando)
//                
//                let actionMovie = SKAction.moveTo(dentePodre.position, duration: 0.5)
//                moeda.runAction(SKAction.sequence([actionMovie]))
//                addChild(moeda)
//                
//                moeda.physicsBody = SKPhysicsBody(circleOfRadius: moeda.size.width/2)
//                moeda.physicsBody?.dynamic = true
//                moeda.physicsBody?.categoryBitMask = PhysicsCategory.Moeda
//                moeda.physicsBody?.contactTestBitMask = PhysicsCategory.DentePodre
//                moeda.physicsBody?.usesPreciseCollisionDetection = true
            }
        }
        
 
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //acao de quando o jogo acaba
        
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let nextScene = GameScene(size: self.size)
        self.view?.presentScene(nextScene, transition: reveal)
    }
    
    func moedaDidCollideWithDentePodre(moeda:SKSpriteNode, dentePodre:SKSpriteNode) {
        println("DP")
        moeda.removeFromParent()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1 seta os dois corpos que sofrerão contato
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2 Analisa os nós que se chocaram e chama o método da colisão
        if (firstBody.categoryBitMask == PhysicsCategory.Moeda && secondBody.categoryBitMask == PhysicsCategory.DentePodre){
            //metodo pra contato com dente podre
            self.moedaDidCollideWithDentePodre(firstBody.node as! SKSpriteNode, dentePodre: secondBody.node as! SKSpriteNode)
        }
    }
    
    func obterNumeros() -> Int{
        return random(0, 100)
    }
    
    func obterOperacoes(operador: String) -> Int{
        let n1 = obterNumeros()
        let n2 = obterNumeros()
        
        var operacao: String = ""
        if(operador == "+"){
            operacao = " \(n1) + \(n2)"
        }else if operador == "-"{
            if n1 > n2{
                operacao = " \(n1) - \(n2)"
            }else {
                operacao = " \(n2) - \(n1)"
            }
        }else if operador == "*" {
            operacao = " \(n1) X \(n2)"
        }else if operador == "/" {
            if n1 > n2 {
                operacao = "\(n1) / \(n2)"
            }else {
                operacao = "\(n2) / \(n1)"
            }
            
        }
        
        self.labelPergunta.text = operacao
        return resolveOperacao(n1, n2: n2, op: operador)
        
    }
    
    func resolveOperacao(n1: Int, n2: Int, op: String) -> Int{
        var resultado: Int = 0
        if(op == "+"){
            resultado = n1 + n2
        }else if op == "-"{
            if n1 > n2{
                resultado = n1 - n2
            }else {
                resultado = n2 - n1
            }
        }else if op == "*" {
            resultado = n1 * n2
        }else if op == "/" {
            if n1 > n2 {
                resultado = n1 / n2
            }else {
                resultado = n2 / n1
            }
        }
        return resultado
    }
    
    func montarScene(){
        background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.size = scene!.size
        background.position = CGPointMake(scene!.size.width/2, scene!.size.height/2)
        scene!.addChild(background)
        
        //label score
        
        labelScore.text = "0"
        labelScore.fontSize = 80
        labelScore.fontColor = SKColor.whiteColor()
        labelScore.position = CGPoint(x: size.width/3, y: 700)
//        addChild(labelScore)
        
        //label Text score
        let labelTextScore = SKLabelNode(fontNamed: "score")
        labelTextScore.text = "Score"
        labelTextScore.fontSize = 80
        labelTextScore.fontColor = SKColor.whiteColor()
        labelTextScore.position = CGPoint(x: size.width/6, y: 700)
//        addChild(labelTextScore)
        
        // musica do app
        playBackgroundMusic("background-music-aac.caf")
        
        superDente1.physicsBody = SKPhysicsBody(rectangleOfSize: superDente1.size)
        superDente2.physicsBody = SKPhysicsBody(rectangleOfSize: superDente2.size)
        superDente3.physicsBody = SKPhysicsBody(rectangleOfSize: superDente3.size)
        dentePodre.physicsBody = SKPhysicsBody(rectangleOfSize: dentePodre.size)
        
        //-----------
        dentePodre.name = "Dente ruim"
        dentePodre.physicsBody?.categoryBitMask = PhysicsCategory.DentePodre
        //------------
        
        // 2 - seta a cor do background da view
        backgroundColor = SKColor.whiteColor()
        // 3 - posiciona o sprite na cena
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        superDente1.position = CGPoint(x: size.width * 0.8, y: size.width * 0.5)
        
        superDente2.position = CGPoint(x: size.width * 0.2, y: size.width * 0.5)
        superDente3.position = CGPoint(x: size.width * 0.5, y: size.width * 0.5)
        dentePodre.position = CGPoint(x: size.width * 0.5, y: size.width * 0.1)
        
        // 4 - adiciona como um "filho" da cena para fazer aparecer na tela
        //        addChild(player)
        addChild(superDente1)
        addChild(superDente2)
        addChild(superDente3)
        addChild(dentePodre)
        
        //setar posicao das labels de respostas
        labelResposta1.position = superDente1.position
        labelResposta1.fontColor = SKColor.blackColor()
        labelResposta1.fontSize = 80
        addChild(labelResposta1)
        
        labelResposta2.position = superDente2.position
        labelResposta2.fontColor = SKColor.blackColor()
        labelResposta2.fontSize = 80
        addChild(labelResposta2)
        
        labelResposta3.position = superDente3.position
        labelResposta3.fontColor = SKColor.blackColor()
        labelResposta3.fontSize = 80
        addChild(labelResposta3)
        
        // setar posicao da label de pergunta
        labelPergunta.position = dentePodre.position
        labelPergunta.fontColor = SKColor.blackColor()
        labelPergunta.fontSize = 80
        
        addChild(labelPergunta)
        // seta que não tem gravidade
        physicsWorld.gravity = CGVectorMake(0, 0)
        // seta o delegate
        physicsWorld.contactDelegate = self
        
        existe = true
    }
}
