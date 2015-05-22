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
    
    //verifica se a scene existe
    var existe:Bool = false
    
    //respostas
    var num1:Int = 0
    var num2:Int = 0
    var num3:Int = 0
    
    //    Adicionando um Sprite
    
    // 1 - declara um sprite (player) privado e constante
    var player:SKSpriteNode!
    var superDente1:SKSpriteNode!
    var superDente2:SKSpriteNode!
    var superDente3:SKSpriteNode!
    var dentePodre:SKSpriteNode!
    var dente:SKSpriteNode!
    
    //Declaração labels das respostas e pergunta e nível
    var labelResposta1:SKLabelNode!
    var labelResposta2:SKLabelNode!
    var labelResposta3:SKLabelNode!
    var labelPergunta:SKLabelNode!
    var labelNivel: SKLabelNode!
    
    var superDenteDestroyed = 0
    var dinheiroDestroyed = 0
    var dentePodreDestroyed = 0
    var background: SKSpriteNode!
    
    var posicao: Int = 0
    
    var represa:SKSpriteNode!
    
    var numeros: Array<Int> = [1,2,3,4,5,6,7,8,9,10]
    
    var nivel: Int = 1
    
    override func didMoveToView(view: SKView) {
        println("didMoveToView - Inicio")
        
        montarScene()
        println("didMoveToView - Nova tela criada")
        
        novoJogo()
        
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
        
        
        // Descobrir qual opção foi tocado
        let denteTocado = self.nodeAtPoint(touchLocation)
        
        // Criar e posicionar label que aparece o texto (feedback ao usuário)
        var labelWin = SKLabelNode(fontNamed: "Marker Felt Wide")
        
        labelWin.position = CGPoint(x: 500, y: 300)
        
        labelWin.fontSize = 80
        
        labelWin.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
        
        // Colocar na label o texto que será mostrado
        if denteTocado.name == "certa" {
            fazerChover()
            labelWin.text = "PARABÉNS!!! Você acertou! "
            nivel++
        }else{
            sairSol()
            labelWin.text = "Que pena...Você errou! "
        }
        
        println("\(denteTocado.name)")
        let aparecer = SKAction.fadeInWithDuration(0.5)
        let esperar = SKAction.waitForDuration(1.5)
        let desaparecer = SKAction.fadeOutWithDuration(0.5)
        
        let sequencia = SKAction.sequence([aparecer, esperar, desaparecer])
        
        // Adicionar label na tela
        labelWin.alpha = 0
        addChild(labelWin)
        
        labelWin.runAction(sequencia, completion: { () -> Void in
            //chama novo nivel
            self.novoJogo()
        })
        
       
        
        
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
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        //acao de quando o jogo acaba
        
//        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//        let nextScene = GameScene(size: self.size)
//        self.view?.presentScene(nextScene, transition: reveal)
//        
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
        var n1: Int = 0
        var n2: Int = 0

        if (nivel >= 1 && nivel <= 2) {
            n1 = random(0, 10)
            n2 = random(0, 10)
        }else if (nivel > 2 && nivel <= 5) {
            n1 = random(0, 20)
            n2 = random(0, 20)
        }else if (nivel > 5 && nivel <= 10) {
            n1 = random(0, 30)
            n2 = random(0, 30)
        }else if (nivel > 10 && nivel <= 25) {
            n1 = random(0, 50)
            n2 = random(0, 50)
        }else{
            n1 = random(0, 100)
            n2 = random(0, 100)
        }
        
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
            n1 = random(1, 20)
            n2 = random(1, 20)
            operacao = " \(n1) × \(n2)"
            
        }else if operador == "/" {
            
            var array = random(0, 9)
            n2 = numeros[array]
            
            do{
                n1 = random(n2, 20)
            }while n1 % n2 != 0
            
            operacao = "\(n1) ÷ \(n2)"
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
            resultado = n1 / n2
        }
        return resultado
    }
    
    func montarScene(){
        self.existe = true
        
        // 1 - declara um sprite (player) privado e constante
        player = SKSpriteNode(imageNamed: "fadinha")
        superDente1 = SKSpriteNode(imageNamed: "nuvem")
        superDente2 = SKSpriteNode(imageNamed: "nuvem")
        superDente3 = SKSpriteNode(imageNamed: "nuvem")
        dentePodre = SKSpriteNode(imageNamed: "nuvem")
        dente = SKSpriteNode(imageNamed: "dente")
        superDente1.zPosition = 1
        superDente2.zPosition = 1
        superDente3.zPosition = 1
        dentePodre.zPosition = 1
        
        //Declaração labels das respostas e pergunta
        labelResposta1 = SKLabelNode()
        labelResposta2 = SKLabelNode()
        labelResposta3 = SKLabelNode()
        labelPergunta = SKLabelNode()
        labelResposta1.zPosition = 1
        labelResposta2.zPosition = 1
        labelResposta3.zPosition = 1
        labelPergunta.zPosition = 1
        
        background = SKSpriteNode(imageNamed: "background")
        background.name = "background"
        background.size = scene!.size
        background.position = CGPointMake(scene!.size.width/2, scene!.size.height/2)
        scene!.addChild(background)
        
        // musica do app
        playBackgroundMusic("background-music-aac.caf")
        
//        superDente1.physicsBody = SKPhysicsBody(rectangleOfSize: superDente1.size)
//        superDente2.physicsBody = SKPhysicsBody(rectangleOfSize: superDente2.size)
//        superDente3.physicsBody = SKPhysicsBody(rectangleOfSize: superDente3.size)
//        dentePodre.physicsBody = SKPhysicsBody(rectangleOfSize: dentePodre.size)
        
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
//        physicsWorld.gravity = CGVectorMake(0, 0)
        // seta o delegate
//        physicsWorld.contactDelegate = self
        
        represa = SKSpriteNode()
        represa.color = SKColor.blueColor()
//        represa.position = CGPointMake(UIScreen.mainScreen().nativeBounds.height / 2, 0)
        represa.position = CGPointMake(0, UIScreen.mainScreen().bounds.height )
        represa.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        addChild(represa)
    }
    
    func novoJogo() {
        println("nivel: \(nivel)")
        labelNivel = SKLabelNode(fontNamed: "Marker Felt Wide")
        labelNivel.position = CGPoint(x: 500, y: 300)
        labelNivel.fontSize = 140
        labelNivel.fontColor = SKColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)

        labelNivel.text = "NIVEL \(nivel)"
        let aparecer = SKAction.fadeInWithDuration(0.5)
        let esperar = SKAction.waitForDuration(1.5)
        let desaparecer = SKAction.fadeOutWithDuration(0.5)
        
        let sequencia = SKAction.sequence([aparecer, esperar, desaparecer])
        
        // Adicionar label na tela
        labelNivel.alpha = 0
        addChild(labelNivel)
        
        labelNivel.runAction(sequencia)
        
                // random para escolher nuvem
        posicao = random(0, 2)
        var num1 = 0
        var num2 = 0
        var num3 = 0
        var resposta: Int = 0
        
        labelResposta1.text = "\(num1)"
        labelResposta2.text = "\(num2)"
        labelResposta3.text = "\(num3)"
        
        superDente1.name = "errado"
        superDente2.name = "errado"
        superDente3.name = "errado"
        
        labelResposta1.name = "errado"
        labelResposta2.name = "errado"
        labelResposta3.name = "errado"
        
        //vericar nivel e filtrar as operacoes para cada bloco de niveis
        //nivel 0 - nivel 10 -> + -
        // nivel 11 - nivel 20 -> + - x
        // nivel 21 - nivel ... -> + - /
        if (nivel >= 0 && nivel <= 10) {
            // random para escolher operação
            var operacao = random(0, 1)
            
            switch operacao {
            case 0:
                resposta = obterOperacoes("+")
            default:
                resposta = obterOperacoes("-")
            }
        }
        else if(nivel > 10 && nivel <= 20) {
            // random para escolher operação
            var operacao = random(0, 2)
            
            switch operacao {
            case 0:
                resposta = obterOperacoes("+")
            case 1:
                resposta = obterOperacoes("-")
            default:
                resposta = obterOperacoes("*")
            }
        }else if(nivel > 20){
            // random para escolher operação
            var operacao = random(0, 3)
            
            switch operacao {
            case 0:
                resposta = obterOperacoes("+")
            case 1:
                resposta = obterOperacoes("-")
            case 2:
                resposta = obterOperacoes("*")
            default:
                resposta = obterOperacoes("/")
            }

        }
        
        switch posicao {
        case 0:
            num2 = random(resposta - 20, resposta - 1)
            if num2 < 0 {
                num2 = (num2 + num2)*(-1) + 2
            }
            
            num3 = random(resposta, resposta + 20)
            
            if num2 == resposta {
                num2++
            }
            if num3 == resposta {
                num3++
            }
            labelResposta1.text = "\(resposta)"
            labelResposta2.text = "\(num2)"
            labelResposta3.text = "\(num3)"
            superDente1.name = "certa"
            labelResposta1.name = "certa"
        case 1:
            num1 = random(resposta - 20, resposta)
            if num1 < 0 {
                num1 = (num1 + num1) * (-1) + 2
            }
            
            num3 = random(resposta, resposta + 20)
            
            if num1 == resposta {
                num1++
            }
            if num3 == resposta {
                num3++
            }
            
            labelResposta1.text = "\(num1)"
            labelResposta2.text = "\(resposta)"
            labelResposta3.text = "\(num3)"
            superDente2.name = "certa"
            labelResposta2.name = "certa"
        default:
            num1 = random(resposta - 20, resposta)
            if num1 < 0 {
                num1 = (num1 - num1) * (-1) + 2
            }
            
            num2 = random(resposta, resposta + 20)
            
            if num1 == resposta {
                num1++
            }
            if num2 == resposta {
                num2++
            }
            
            labelResposta1.text = "\(num1)"
            labelResposta2.text = "\(num2)"
            labelResposta3.text = "\(resposta)"
            superDente3.name = "certa"
            labelResposta3.name = "certa"
        }
        
        println("\(resposta) e \(num1) e \(num2) e \(posicao)")

    }
    
    func fazerChover() {
        
        let nuvemChovendo: SKSpriteNode!
        
        switch posicao {
        case 0:
            nuvemChovendo = superDente1
        case 1:
            nuvemChovendo = superDente2
        default:
            nuvemChovendo = superDente3
        }
        

        let chuva: SKNode = SKNode()
        
        for var i = 0; i < random(10, 20); i++ {
            let gota: SKSpriteNode = SKSpriteNode(imageNamed: "gota")
            let posicaoX = random(Int(nuvemChovendo.position.x - nuvemChovendo.size.width / 3), Int(nuvemChovendo.position.x + nuvemChovendo.size.width / 3))
            let posicaoY = random(Int(nuvemChovendo.position.y), Int(nuvemChovendo.position.y + nuvemChovendo.size.height / 2))
            gota.position = CGPointMake(CGFloat(posicaoX),CGFloat(posicaoY))
            gota.xScale = 0.75
            gota.yScale = 0.75
            chuva.addChild(gota)
        }
        
//        chuva.position = nuvemChovendo.position
        addChild(chuva)
        
        let chover: SKAction = SKAction.moveTo(CGPointMake(chuva.position.x, UIScreen.mainScreen().bounds.height * -2), duration: 1.0)
        chuva.runAction(chover, completion: { () -> Void in
            chuva.removeFromParent()
        })
        
        represa.position.y = represa.position.y + 10
    }
    
    //caso erre a conta essa funçao será chamada
    func sairSol(){
        var sol: SKSpriteNode = SKSpriteNode(imageNamed: "sol")
        
        sol.zPosition = 1
        let nuvemChovendo: SKSpriteNode!
        
        switch posicao {
        case 0:
            nuvemChovendo = superDente1
            superDente1.removeFromParent()
        case 1:
            nuvemChovendo = superDente2
            superDente2.removeFromParent()
        default:
            nuvemChovendo = superDente3
            superDente3.removeFromParent()
        }
        
        let posicaoX = nuvemChovendo.position.x
        let posicaoY = nuvemChovendo.position.y
        
        sol.position = CGPointMake(CGFloat(posicaoX),CGFloat(posicaoY))

        addChild(sol)
        
//        represa.position.y = represa.position.y - 10
    }
}
