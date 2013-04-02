class ApplicationController < ActionController::Base
  before_filter :defineAnimations, :only => :build
  protect_from_forgery

  def index
  end

  def build
    filename = 'app/assets/javascripts/animatio.template.js'
    output = 'tmp/jquery.animatio.js'

    File.open(output,'w') do |filea|
      File.open(filename,'r') do |fileb|
        while line = fileb.gets
          if line.match(/<<<EFFECTS>>>/)
            addAnimations(params[:animations] || [], filea)
          else
            filea.puts line
          end
        end
      end
    end

    extname = File.extname(output)[1..-1]
    mime_type = Mime::Type.lookup_by_extension(extname)
    content_type = mime_type.to_s unless mime_type.nil?

    render :file => output, :content_type => content_type
  end

  private

  def addAnimations(animations, desc)
    animations.each do |animation|
      desc.puts @anims[animation.to_sym]
    end
  end

  def defineAnimations
    @anims = {
      bounce:'    bounce:"0%, 20%, 50%, 80%, 100% {{browser}transform: translateY(0);}40% {{browser}transform: translateY(-30px);}60% {{browser}transform: translateY(-15px);}",',
      bounceIn:'    bounceIn:"0% {opacity: 0;{browser}transform: scale(.3);}50% {opacity: 1;{browser}transform: scale(1.05);}70% {{browser}transform: scale(.9);}100% {{browser}transform: scale(1);}",',
      bounceInUp:'    bounceInUp:"0% {opacity: 0;{browser}transform: translateY(100%);}60% {opacity: 1;{browser}transform: translateY(-30px);}80% {{browser}transform: translateY(10px);}100% {{browser}transform: translateY(0);}",',
      bounceInDown:'    bounceInDown:"0% {opacity: 0;{browser}transform: translateY(-100%);}60% {opacity: 1;{browser}transform: translateY(30px);}80% {{browser}transform: translateY(-10px);}100% {{browser}transform: translateY(0);}",',
      bounceInLeft:'    bounceInLeft:"0% {opacity: 0;{browser}transform: translateX(-100%);}60% {opacity: 1;{browser}transform: translateX(30px);}80% {{browser}transform: translateX(-10px);}100% {{browser}transform: translateX(0);}",',
      bounceInRight:'    bounceInRight:"0% {opacity: 0;{browser}transform: translateX(100%);}60% {opacity: 1;{browser}transform: translateX(-30px);}80% {{browser}transform: translateX(10px);}100% {{browser}transform: translateX(0);}",',
      bounceOut:'    bounceOut:"0% {{browser}transform: scale(1);}25% {{browser}transform: scale(.95);}50% {opacity: 1;{browser}transform: scale(1.1);}100% {opacity: 0;{browser}transform: scale(.3);}",',
      bounceOutUp:'    bounceOutUp:"0% {{browser}transform: translateY(0);}20% {opacity: 1;{browser}transform: translateY(20px);}100% {opacity: 0;{browser}transform: translateY(-100%);}",',
      bounceOutDown:'    bounceOutDown:"0% {{browser}transform: translateY(0);}20% {opacity: 1;{browser}transform: translateY(-20px);}100% {opacity: 0;{browser}transform: translateY(100%);}",',
      bounceOutLeft:'    bounceOutLeft:"0% {{browser}transform: translateX(0);}20% {opacity: 1;{browser}transform: translateX(20px);}100% {opacity: 0;{browser}transform: translateX(-100%);}",',
      bounceOutRight:'    bounceOutRight:"0% {{browser}transform: translateX(0);}20% {opacity: 1;{browser}transform: translateX(-20px);}100% {opacity: 0;{browser}transform: translateX(100%);}",',
      fadeIn:'    fadeIn:"0% {opacity: 0;}100% {opacity: 1;}",',
      fadeInUp:'    fadeInUp:"0% {opacity: 0;{browser}transform: translateY(50px);}100% {opacity: 1;{browser}transform: translateY(0);}",',
      fadeInDown:'    fadeInDown:"0% {opacity: 0;{browser}transform: translateY(-50px);}100% {opacity: 1;{browser}transform: translateY(0);}",',
      fadeInLeft:'    fadeInLeft:"0% {opacity: 0;{browser}transform: translateX(-20px);}100% {opacity: 1;{browser}transform: translateX(0);}",',
      fadeInRight:'    fadeInRight:"0% {opacity: 0;{browser}transform: translateX(20px);}100% {opacity: 1;{browser}transform: translateX(0);}",',
      fadeInUpBig:'    fadeInUpBig:"0% {opacity: 0;{browser}transform: translateY(100%);}100% {opacity: 1;{browser}transform: translateY(0);}",',
      fadeInDownBig:'    fadeInDownBig:"0% {opacity: 0;{browser}transform: translateY(-100%);}100% {opacity: 1;{browser}transform: translateY(0);}",',
      fadeInLeftBig:'    fadeInLeftBig:"0% {opacity: 0;{browser}transform: translateX(-100%);}100% {opacity: 1;{browser}transform: translateX(0);}",',
      fadeInRightBig:'    fadeInRightBig:"0% {opacity: 0;{browser}transform: translateX(100%);}100% {opacity: 1;{browser}transform: translateX(0);}",',
      fadeOut:'    fadeOut:"0% {opacity: 1;}100% {opacity: 0;}",',
      fadeOutUp:'    fadeOutUp:"0% {opacity: 1;{browser}transform: translateY(0);}100% {opacity: 0;{browser}transform: translateY(-50px);}",',
      fadeOutDown:'    fadeOutDown:"0% {opacity: 1;{browser}transform: translateY(0);}100% {opacity: 0;{browser}transform: translateY(50px);}",',
      fadeOutLeft:'    fadeOutLeft:"0% {opacity: 1;{browser}transform: translateX(0);}100% {opacity: 0;{browser}transform: translateX(-20px);}",',
      fadeOutRight:'    fadeOutRight:"0% {opacity: 1;{browser}transform: translateX(0);}100% {opacity: 0;{browser}transform: translateX(20px);}",',
      fadeOutUpBig:'    fadeOutUpBig:"0% {opacity: 1;{browser}transform: translateY(0);}100% {opacity: 0;{browser}transform: translateY(-100%);}",',
      fadeOutDownBig:'    fadeOutDownBig:"0% {opacity: 1;{browser}transform: translateY(0);}100% {opacity: 0;{browser}transform: translateY(100%);}",',
      fadeOutLeftBig:'    fadeOutLeftBig:"0% {opacity: 1;{browser}transform: translateX(0);}100% {opacity: 0;{browser}transform: translateX(-100%);}",',
      fadeOutRightBig:'    fadeOutRightBig:"0% {opacity: 1;{browser}transform: translateX(0);}100% {opacity: 0;{browser}transform: translateX(100%);}",',
      flash:'    flash:"0%, 50%, 100% {opacity: 1;}25%, 75% {opacity: 0;}",',
      flipIn:'    flipIn:"0% { {browser}transform: rotateY(0) } 100% { {browser}transform: rotateY(180deg) }",',
      flipInY:'    flipInY:"0% {{browser}transform: perspective(400px) rotateX(90deg);opacity: 0;}40% {{browser}transform: perspective(400px) rotateX(-10deg);}70% {{browser}transform: perspective(400px) rotateX(10deg);}100% {{browser}transform: perspective(400px) rotateX(0deg);opacity: 1;}",',
      flipInX:'    flipInX:"0% {{browser}transform: perspective(400px) rotateY(90deg);opacity: 0;}40% {{browser}transform: perspective(400px) rotateY(-10deg);}70% {{browser}transform: perspective(400px) rotateY(10deg);}100% {{browser}transform: perspective(400px) rotateY(0deg);opacity: 1;}",',
      flipOut:'    flipOut:"0% { {browser}transform: rotateY(180deg) } 100% { {browser}transform: rotateY(0) }",',
      flipOutY:'    flipOutY:"0% {{browser}transform: perspective(400px) rotateX(0deg);opacity: 1;}100% {{browser}transform: perspective(400px) rotateX(90deg);opacity: 0;}",',
      flipOutX:'    flipOutX:"0% {{browser}transform: perspective(400px) rotateY(0deg);opacity: 1;}100% {{browser}transform: perspective(400px) rotateY(90deg);opacity: 0;}",',
      hinge:'    hinge:"0% { {browser}transform: rotate(0); {browser}transform-origin: top left; {browser}animation-timing-function: ease-in-out; }20%, 60% { {browser}transform: rotate(80deg); {browser}transform-origin: top left; {browser}animation-timing-function: ease-in-out; }40% { {browser}transform: rotate(60deg); {browser}transform-origin: top left; {browser}animation-timing-function: ease-in-out; }80% { {browser}transform: rotate(60deg) translateY(0); opacity: 1; {browser}transform-origin: top left; {browser}animation-timing-function: ease-in-out; }100% { {browser}transform: translateY(700px); opacity: 0; }",',
      lightSpeedIn:'    lightSpeedIn:"0% { {browser}transform: translateX(100%) skewX(-30deg); opacity: 0; }60% { {browser}transform: translateX(-20%) skewX(30deg); opacity: 1; }80% { {browser}transform: translateX(0%) skewX(-15deg); opacity: 1; }100% { {browser}transform: translateX(0%) skewX(0deg); opacity: 1; }",',
      lightSpeedOut:'    lightSpeedOut:"0% { {browser}transform: translateX(0%) skewX(0deg); opacity: 1; }100% { {browser}transform: translateX(100%) skewX(-30deg); opacity: 0; }",',
      pulse:'    pulse:"0% { {browser}transform: scale(1); }50% { {browser}transform: scale(1.1); }100% { {browser}transform: scale(1); }",',
      rollIn:'    rollIn:"0% { opacity: 0; {browser}transform: translateX(-100%) rotate(-120deg); }100% { opacity: 1; {browser}transform: translateX(0px) rotate(0deg); }",',
      rollOut:'    rollOut:"0% {opacity: 1;{browser}transform: translateX(0px) rotate(0deg);}100% {opacity: 0;{browser}transform: translateX(100%) rotate(120deg);}",',
      rotateIn:'    rotateIn:"0% {{browser}transform-origin: center center;{browser}transform: rotate(-200deg);opacity: 0;}100% {{browser}transform-origin: center center;{browser}transform: rotate(0);opacity: 1;}",',
      rotateInUpLeft:'    rotateInUpLeft:"0% {{browser}transform-origin: left bottom;{browser}transform: rotate(90deg);opacity: 0;}100% {{browser}transform-origin: left bottom;{browser}transform: rotate(0);opacity: 1;}",',
      rotateInDownLeft:'    rotateInDownLeft:"0% {{browser}transform-origin: left bottom;{browser}transform: rotate(-90deg);opacity: 0;}100% {{browser}transform-origin: left bottom;{browser}transform: rotate(0);opacity: 1;}",',
      rotateInUpRight:'    rotateInUpRight:"0% {{browser}transform-origin: right bottom;{browser}transform: rotate(-90deg);opacity: 0;}100% {{browser}transform-origin: right bottom;{browser}transform: rotate(0);opacity: 1;}",',
      rotateInDownRight:'    rotateInDownRight:"0% {{browser}transform-origin: right bottom;{browser}transform: rotate(90deg);opacity: 0;}100% {{browser}transform-origin: right bottom;{browser}transform: rotate(0);opacity: 1;}",',
      rotateOut:'    rotateOut:"0% {{browser}transform-origin: center center;{browser}transform: rotate(0);opacity: 1;}100% {{browser}transform-origin: center center;{browser}transform: rotate(200deg);opacity: 0;}",',
      rotateOutUpLeft:'    rotateOutUpLeft:"0% {{browser}transform-origin: left bottom;{browser}transform: rotate(0);opacity: 1;}100% {{browser}transform-origin: left bottom;{browser}transform: rotate(-90deg);opacity: 0;}",',
      rotateOutDownLeft:'    rotateOutDownLeft:"0% {{browser}transform-origin: left bottom;{browser}transform: rotate(0);opacity: 1;}100% {{browser}transform-origin: left bottom;{browser}transform: rotate(90deg);opacity: 0;}",',
      rotateOutUpRight:'    rotateOutUpRight:"0% {{browser}transform-origin: right bottom;{browser}transform: rotate(0);opacity: 1;}100% {{browser}transform-origin: right bottom;{browser}transform: rotate(90deg);opacity: 0;}",',
      rotateOutDownRight:'    rotateOutDownRight:"0% {{browser}transform-origin: right bottom;{browser}transform: rotate(0);opacity: 1;}100% {{browser}transform-origin: right bottom;{browser}transform: rotate(-90deg);opacity: 0;}",',
      slideInLeft:'    slideInLeft:"0% {{browser}transform: translateX(-100%);}100% {{browser}transform: translateX(0);}",',
      slideInRight:'    slideInRight:"0% {{browser}transform: translateX(100%);}100% {{browser}transform: translateX(0);}",',
      slideOutLeft:'    slideOutLeft:"0% {{browser}transform: translateX(0);}100% {{browser}transform: translateX(-100%);}",',
      slideOutRight:'    slideOutRight:"0% {{browser}transform: translateX(0%);}100% {{browser}transform: translateX(100%);}",',
      shake:'    shake:"0%, 100% {{browser}transform: translateX(0);}10%, 30%, 50%, 70%, 90% {{browser}transform: translateX(-10px);}20%, 40%, 60%, 80% {{browser}transform: translateX(10px);}",',
      swing:'    swing:"20%, 40%, 60%, 80%, 100% { {browser}transform-origin: top center; }20% { {browser}transform: rotate(15deg); }40% { {browser}transform: rotate(-10deg); }60% { {browser}transform: rotate(5deg); }80% { {browser}transform: rotate(-5deg); }100% { {browser}transform: rotate(0deg); }",',
      tada:'    tada:"0% {{browser}transform: scale(1);}10%, 20% {{browser}transform: scale(0.9) rotate(-3deg);}30%, 50%, 70%, 90% {{browser}transform: scale(1.1) rotate(3deg);}40%, 60%, 80% {{browser}transform: scale(1.1) rotate(-3deg);}100% {{browser}transform: scale(1) rotate(0);}",',
      wiggle:'    wiggle:"0% { {browser}transform: skewX(9deg); }10% { {browser}transform: skewX(-8deg); }20% { {browser}transform: skewX(7deg); }30% { {browser}transform: skewX(-6deg); }40% { {browser}transform: skewX(5deg); }50% { {browser}transform: skewX(-4deg); }60% { {browser}transform: skewX(3deg); }70% { {browser}transform: skewX(-2deg); }80% { {browser}transform: skewX(1deg); }90% { {browser}transform: skewX(0deg); }100% { {browser}transform: skewX(0deg); }",',
      wobble:'    wobble:"0% { {browser}transform: translateX(0%); }15% { {browser}transform: translateX(-25%) rotate(-5deg); }30% { {browser}transform: translateX(20%) rotate(3deg); }45% { {browser}transform: translateX(-15%) rotate(-3deg); }60% { {browser}transform: translateX(10%) rotate(2deg); }75% { {browser}transform: translateX(-5%) rotate(-1deg); }100% { {browser}transform: translateX(0%); }",',
      zoomIn:'    zoomIn: "0% {opacity: 0;{browser}transform: scale(.1);} 100% {{browser}transform: scale(1);}",',
      zoomInCurved:'    zoomInCurved:"0% { {browser}transform: scale(0) translateX(-100%) translateY(-100%) } 100% { {browser}transform: scale(1) translateX(0) translateY(0) }",',
      zoomInFlip:'    zoomInFlip:"0% { {browser}transform: scale(0) translateX(-100%) translateY(-100%) rotate(45deg) rotateX(-180deg) rotateY(-180deg) } 100% { {browser}transform: scale(1) translateX(0) translateY(0) rotate(0deg) rotateX(0deg) rotateY(0deg) }",',
      zoomOut:'    zoomOut: "0% {{browser}transform: scale(1);} 100% { opacity: 0; {browser}transform: scale(.1);}",',
      zoomOutCurved:'    zoomOutCurved:"0% { {browser}transform: scale(1) translateX(0) translateY(0) } 100% { {browser}transform: scale(0) translateX(-100%)  translateY(-100%) }",',
      zoomOutFlip:'    zoomOutFlip:"0% { {browser}transform: scale(1) translateX(0) translateY(0) rotate(0deg) rotateX(0deg) rotateY(0deg) } 100% { {browser}transform: scale(0) translateX(-100%) translateY(-100%) rotate(45deg) rotateX(-180deg) rotateY(-180deg) }",'
    }
  end

end

