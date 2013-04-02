class ApplicationController < ActionController::Base
  before_filter :defineAnimations, :only => :build
  before_filter :defineScrollingAnimations, :only => :build
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
          elsif line.match(/<<<SCROLLING>>>/)
            addScrollingAnimations(params[:scrolling] || [], filea)
          else
            filea.puts line
          end
        end
      end
    end

    extname = File.extname(output)[1..-1]
    mime_type = Mime::Type.lookup_by_extension(extname)
    content_type = mime_type.to_s unless mime_type.nil?

    # render :file => output, :content_type => content_type
    send_file output
  end

  private

  def addAnimations(animations, desc)
    animations.each do |animation|
      desc.puts @anims[animation.to_sym]
    end
  end

  def addScrollingAnimations(animations, desc)
    animations.each do |animation|
      desc.puts @scrolling[animation.to_sym]
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

  def defineScrollingAnimations
    @scrolling = {
      cards: ' cards: ".cards { {browser}perspective: 300px; perspective: 300px; {browser}perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .cards {cls} { {browser}transition: all 600ms ease; {browser}transform-origin: 100% 50%; transform-origin: 100% 50%; } .cards {cls}.past { {browser}transform: translate3d( 0, -100px, -100px ) rotateX( -90deg ); transform: translate3d( 0, -100px, -100px ) rotateX( -90deg ); } .cards {cls}.future { {browser}transform: translate3d( 0, 100px, -100px ) rotateX( 90deg ); transform: translate3d( 0, 100px, -100px ) rotateX( 90deg ); }"',
      curl: ' curl: ".curl{-webkit-transform: translateZ(0); -webkit-perspective:600px;-moz-perspective:600px;-ms-perspective:600px;-o-perspective:600px;perspective:600px;-webkit-perspective-origin:0 50%;-moz-perspective-origin:0 50%;-ms-perspective-origin:0 50%;-o-perspective-origin:0 50%;perspective-origin:0 50%}.curl {cls}{-webkit-transition:all 600ms ease,opacity 200ms ease;-moz-transition:all 600ms ease;-ms-transition:all 600ms ease,opacity 200ms ease;-o-transition:all 600ms ease,opacity 200ms ease;transition:all 600ms ease,opacity 200ms ease;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-ms-transform-origin:0 0;-o-transform-origin:0 0;transform-origin:0 0;-webkit-backface-visibility:hidden;-moz-backface-visibility:hidden;-ms-backface-visibility:hidden;-o-backface-visibility:hidden;backface-visibility:hidden}.curl {cls}.past{opacity:0; -webkit-transform: translateZ(0); -webkit-transform:rotateY(90deg);-moz-transform:rotateY(90deg);-ms-transform:rotateY(90deg);-o-transform:rotateY(90deg);transform:rotateY(90deg)}.curl {cls}.future{opacity:0;-webkit-transform:rotateY(90deg);-moz-transform:rotateY(90deg);-ms-transform:rotateY(90deg);-o-transform:rotateY(90deg);transform:rotateY(90deg)}"',
      fader: ' fader: ".fader {cls} { {browser}transition: opacity .35s ease-in-out; } .fader {cls}.past { opacity: 0; } .fader {cls}.future { opacity: 0; }"',
      fan: ' fan: ".fan {cls} { {browser}transition: all 600ms cubic-bezier(0.390, 0.575, 0.565, 1.000); {browser}transform-origin: 0% 0%; } .fan {cls}.past { {browser}transform: rotate( -60deg ); } .fan {cls}.future { {browser}transform: rotate( 70deg ); }"',
      flip: ' flip: ".flip { -webkit-perspective: 400px; -moz-perspective: 400px; -ms-perspective: 400px; -o-perspective: 400px; perspective: 400px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .flip {cls} { -webkit-transition: all 600ms ease, opacity 300ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 300ms ease; -o-transition: all 600ms ease, opacity 300ms ease; transition: all 600ms ease, opacity 300ms ease; -webkit-transform-origin: 0% 0%; -moz-transform-origin: 0% 0%; -ms-transform-origin: 0% 0%; -o-transform-origin: 0% 0%; transform-origin: 0% 0%; } .flip {cls}.past { opacity: 0; -webkit-transform-origin: 0% 100%; -moz-transform-origin: 0% 100%; -ms-transform-origin: 0% 100%; -o-transform-origin: 0% 100%; transform-origin: 0% 100%; -webkit-transform: rotateX( 80deg ); -moz-transform: rotateX( 80deg ); -ms-transform: rotateX( 80deg ); -o-transform: rotateX( 80deg ); transform: rotateX( 80deg ); } .flip {cls}.future { opacity: 0; -webkit-transform: rotateX( -80deg ); -moz-transform: rotateX( -80deg ); -ms-transform: rotateX( -80deg ); -o-transform: rotateX( -80deg ); transform: rotateX( -80deg ); }"',
      fly: ' fly: ".fly { -webkit-perspective: 2000px; -moz-perspective: 2000px; -ms-perspective: 2000px; -o-perspective: 2000px; perspective: 2000px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .fly {cls} { -webkit-transition: all 600ms ease, opacity 300ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 300ms ease; -o-transition: all 600ms ease, opacity 300ms ease; transition: all 600ms ease, opacity 300ms ease; -webkit-transform-origin: 50% 50% -50px; -moz-transform-origin: 50% 50% -50px; -ms-transform-origin: 50% 50% -50px; -o-transform-origin: 50% 50% -50px; transform-origin: 50% 50% -50px; } .fly {cls}.past { opacity: 0; -webkit-transform: rotateX( -180deg ); -moz-transform: rotateX( -180deg ); -ms-transform: rotateX( -180deg ); -o-transform: rotateX( -180deg ); transform: rotateX( -180deg ); } .fly {cls}.future { opacity: 0; -webkit-transform: rotateX( 180deg ); -moz-transform: rotateX( 180deg ); -ms-transform: rotateX( 180deg ); -o-transform: rotateX( 180deg ); transform: rotateX( 180deg ); }"',
      grow: ' grow: ".grow {cls}{ {browser}transition: all 600ms ease; {browser}transform-origin: 50% 50%; } .grow {cls}.past { {browser}transform: scale( 0.01 ); } .grow {cls}.future {{browser}transform: scale( 0.01 ); }"',
      helix: ' helix: ".helix{-webkit-perspective:600px;-moz-perspective:600px;-ms-perspective:600px;-o-perspective:600px;perspective:600px;-webkit-perspective-origin:50% 50%;-moz-perspective-origin:50% 50%;-ms-perspective-origin:50% 50%;-o-perspective-origin:50% 50%;perspective-origin:50% 50%}.helix {cls}{-webkit-transition:all 600ms ease,opacity 200ms ease;-moz-transition:all 600ms ease;-ms-transition:all 600ms ease,opacity 200ms ease;-o-transition:all 600ms ease,opacity 200ms ease;transition:all 600ms ease,opacity 200ms ease;-webkit-transform-origin:50% 50%;-moz-transform-origin:50% 50%;-ms-transform-origin:50% 50%;-o-transform-origin:50% 50%;transform-origin:50% 50%}.helix {cls}.past{opacity:0;-webkit-transform:rotateY(180deg);-moz-transform:rotateY(180deg);-ms-transform:rotateY(180deg);-o-transform:rotateY(180deg);transform:rotateY(180deg)}.helix {cls}.future{opacity:0;-webkit-transform:rotateY(-180deg);-moz-transform:rotateY(-180deg);-ms-transform:rotateY(-180deg);-o-transform:rotateY(-180deg);transform:rotateY(-180deg)}"',
      papercut: ' papercut: ".papercut { {browser}perspective: 600px; {browser}perspective-origin: 0% 0%; } .papercut {cls} { {browser}transition: all 600ms ease; {browser}transform-origin: 0% 0%; } .papercut {cls}.past { {browser}transform: skewY( -30deg ); } .papercut {cls}.future { {browser}transform: skewY( 30deg ); }"',
      slide: ' slide: ".slide {cls} { {browser}transition: all 600ms cubic-bezier(0.260, 0.860, 0.440, 0.985); } .slide {cls}.past { {browser}transform: translateX( -70% ); } .slide {cls}.future { {browser}transform: translateX( -70% ); }"',
      twirl: ' twirl: ".twirl { -webkit-perspective: 400px; -moz-perspective: 400px; -ms-perspective: 400px; -o-perspective: 400px; perspective: 400px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .twirl {cls} { -webkit-transition: all 600ms ease, opacity 200ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 200ms ease; -o-transition: all 600ms ease, opacity 200ms ease; transition: all 600ms ease, opacity 200ms ease; -webkit-transform-origin: 50% 50%; -moz-transform-origin: 50% 50%; -ms-transform-origin: 50% 50%; -o-transform-origin: 50% 50%; transform-origin: 50% 50%; } .twirl {cls}.past { opacity: 0; -webkit-transform: rotate3d( 80,-70,10,180deg ); -moz-transform: rotate3d( 80,70,10,180deg ); -ms-transform: rotate3d( 80,70,10,180deg ); -o-transform: rotate3d( 80,70,10,180deg ); transform: rotate3d( 80,70,10,180deg ); } .twirl {cls}.future { opacity: 0; -webkit-transform: rotate3d( 80,70,10,-180deg ); -moz-transform: rotate3d( 80,70,10,-180deg ); -ms-transform: rotate3d( 80,70,10,-180deg ); -o-transform: rotate3d( 80,70,10,-180deg ); transform: rotate3d( 80,70,10,-180deg ); }"',
      zipper: ' zipper: ".zipper {cls} { {browser}transition: all 600ms cubic-bezier(0.390, 0.575, 0.565, 1.000); {browser}transform-origin: 50% 0%; } .zipper {cls}.past:nth-child(odd), .zipper {cls}.future:nth-child(odd) { {browser}transform: translateX( 80% ); } .zipper {cls}.past:nth-child(even), .zipper {cls}.future:nth-child(even) { {browser}transform: translateX( -80% ); }"'
    }
  end

end
