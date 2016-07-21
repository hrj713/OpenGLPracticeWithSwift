//
//  GLView.swift
//  ESLearn
//
//  Created by ken.han on 7/21/16.
//  Copyright © 2016 ken.han. All rights reserved.
//

import UIKit

class GLView: UIView {
    
    var gllayer: CAEAGLLayer!
    var context: EAGLContext!
    var colorRenderBuffer: GLuint = 0
    var frameBuffer: GLuint = 0
    
    
    override class func layerClass() -> AnyClass {
        return CAEAGLLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
        setupContext()
        destoryBuffers()
        setupRenderBuffer()
        setupFrameBuffer()
        render()
    }
    
    func setupLayer() {
        gllayer = self.layer as! CAEAGLLayer
        gllayer.opaque = true
        gllayer.drawableProperties = [false: kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8: kEAGLDrawablePropertyColorFormat]
    }

    func setupContext() {
        context = EAGLContext(API: .OpenGLES3)
        EAGLContext.setCurrentContext(context)
    }
    
    func setupRenderBuffer() {
        glGenRenderbuffers(1, &colorRenderBuffer)
        glBindRenderbuffer(UInt32(GL_RENDERBUFFER), colorRenderBuffer)
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: gllayer)
    }
    
    func setupFrameBuffer() {
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(UInt32(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(UInt32(GL_FRAMEBUFFER), UInt32(GL_COLOR_ATTACHMENT0), UInt32(GL_RENDERBUFFER), colorRenderBuffer)
    }
    
    func destoryBuffers() {
        glDeleteRenderbuffers(1, &colorRenderBuffer)
        colorRenderBuffer = 0
        glDeleteFramebuffers(1, &frameBuffer)
        frameBuffer = 0
    }
    
    func render() {
        glClearColor(0, 1, 0, 1)
        glClear(UInt32(GL_COLOR_BUFFER_BIT))
        context.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
}
