//
//  GameScene.swift
//  Teste1_SpriteKit
//
//  Created by Patricia de Abreu on 04/05/15.
//  Copyright (c) 2015 Patricia de Abreu. All rights reserved.
//

import SpriteKit
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let SuperDente   : UInt32 = 0b10       // 2
    static let Dinheiro     : UInt32 = 0b11    //3
    static let DentePodre   : UInt32 = 0b110   //4
    static let Moeda        : UInt32 = 0b1      // 1
}

func random(lo: Int, hi : Int) -> Int {
    return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
}


//let actualDinheiroDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))

/////////////////////////////////

//implementar o delegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
        //respostas
    var num1:Int = 0
    var num2:Int = 0
    //    Adicionando um Sprite
    // 1 - declara um sprite (player) privado e constante
    let player = SKSpriteNode(imageNamed: "fadinha")
    let superDente1 = SKSpriteNode(imageNamed: "superDente")
    let superDente2 = SKSpriteNode(imageNamed: "superDente")
    let superDente3 = SKSpriteNode(imageNamed: "superDente")
    let dentePodre = SKSpriteNode(imageNamed: "dentePodre")
    let dente = SKSpriteNode(imageNamed: "dente")

    //Declaração labels das respostas e pergunta
    var labelResposta1 = SKLabelNode(fontNamed: "resposta1")
    var labelPergunta = SKLabelNode(fontNamed: "pergunta")
    
    var superDenteDestroyed = 0
    var dinheiroDestroyed = 0
    var dentePodreDestroyed = 0
    var score = 0
    var background: SKSpriteNode!
    let labelScore = SKLabelNode(fontNamed: "score")
    
    override func didMoveToView(view: SKView) {
        
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
        addChild(labelScore)
        
        //label Text score
        let labelTextScore = SKLabelNode(fontNamed: "score")
        labelTextScore.text = "Score"
        labelTextScore.fontSize = 80
        labelTextScore.fontColor = SKColor.whiteColor()
        labelTextScore.position = CGPoint(x: size.width/6, y: 700)
        addChild(labelTextScore)
        
        // musica do app
        playBackgroundMusic("background-music-aac.caf")

        superDente1.physicsBody = SKPhysicsBody(rectangleOfSize: superDente1.size)
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
        
        // setar posicao da label de pergunta
        labelPergunta.position = dentePodre.position
        labelPergunta.fontColor = SKColor.blackColor()
        labelPergunta.fontSize = 80
        
        addChild(labelPergunta)
        // seta que não tem gravidade
        physicsWorld.gravity = CGVectorMake(0, 0)
        // seta o delegate
        physicsWorld.contactDelegate = self
        
        let posicao = random(0, 2)
        var resposta: Int
        if (posicao == 0){
            resposta = obterOperacoes("+")
        }else if(posicao == 1){
            resposta = obterOperacoes("+")
        }else if(posicao == 2){
            resposta = obterOperacoes("+")
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
        
        
        if superDente1.containsPoint(touchLocation){
            dentePodre.position = CGPoint(x: size.width * 0.8, y: size.width * 0.1)
            moeda.position = superDente1.position
            moeda.xScale = 1
            moeda.yScale = 1
            animarMoeda(moeda, imagens: imagensMoedaGirando)

            let actionMovie = SKAction.moveTo(dentePodre.position, duration: 2.0)
            moeda.runAction(SKAction.sequence([actionMovie]))
            addChild(moeda)
            
            moeda.physicsBody = SKPhysicsBody(circleOfRadius: moeda.size.width/2)
            moeda.physicsBody?.dynamic = true
            moeda.physicsBody?.categoryBitMask = PhysicsCategory.Moeda
            moeda.physicsBody?.contactTestBitMask = PhysicsCategory.DentePodre
            moeda.physicsBody?.usesPreciseCollisionDetection = true
            
        }else if superDente2.containsPoint(touchLocation) {
            dente.position = superDente2.position
            superDente2.removeFromParent()
            addChild(dente)
        }
        
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
            
        }
        return resultado

    }
}
