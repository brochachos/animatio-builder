/**!
 *                                          __
 *                 __                      /\ \__  __
 *    __      ___ /\_\    ___ ___      __  \ \ ,_\/\_\    ___
 *  /'__`\  /' _ `\/\ \ /' __` __`\  /'__`\ \ \ \/\/\ \  / __`\
 * /\ \L\.\_/\ \/\ \ \ \/\ \/\ \/\ \/\ \L\.\_\ \ \_\ \ \/\ \L\ \
 * \ \__/.\_\ \_\ \_\ \_\ \_\ \_\ \_\ \__/.\_\\ \__\\ \_\ \____/
 *  \/__/\/_/\/_/\/_/\/_/\/_/\/_/\/_/\/__/\/_/ \/__/ \/_/\/___/
 *
 *
 * @package   animatio.js - jQuery CSS3 Animation Plugins
 *
 * @author    Kieran Boyle (github.com/dysfunc)
 * @author    Sergio Almecija (github.com/sheniff)
 *
 * @copyright 2012, 2013 Kieran Boyle and Sergio Almecija
 * @license   github.com/dysfunc/animatio/license.txt
 * @version   1.0
 * @link      github.com/dysfunc/animatio
 */

 (function(window, $){
  "use strict";

  /*------------------------------------
   * Baked in effects
   ------------------------------------*/

  $.effect = {
    // <<<EFFECTS>>>
  };

  var global = window,
      document = global.document,
      documentElement = document.documentElement,
      navigator = global.navigator,
      agent = navigator.userAgent,
      // browser prefix
      prefix = (/webkit/i).test(agent) ? '-webkit-' : (/firefox/i).test(agent) ? '-moz-' : (/opera/i).test(agent) ? '-o-' : (/msie/i).test(agent) ? '-ms-' : '',
      // cleaned prefix
      cleaned = prefix.replace(/-/g, ''),
      // CSS cache object
      cache = {},
      // CSS transition reset object
      reset = {},
      // reference to inline style block
      style = null,
      // animation configuration
      properties = /^(property|delay|duration)$/i,
      // check if touch is supported
      supportsTouch = ('ontouchstart' in window),
      // CSS transforms
      transforms = /^((perspective|rotate|scale|skew|translate)(X|Y|Z|3d)?|matrix(3d)?)$/i,
      // transition end map
      animationEnd = { webkit: 'webkitTransitionEnd', moz: 'transitionend', o: 'oTransitionEnd', ms: 'transitionend' },
      /**
       * Determines if we've already created our inline style block to store our animation rules in
       * @return {Boolean} Always returns the value of true
       */
      createStyle = function(){
        if(!style){
          style = document.createElement('style');
          style.setAttribute('type', 'text/css');
          document.getElementsByTagName('head')[0].appendChild(style);
        }
        return true;
      },
      /**
       * Replaces template keys with object property values
       * @param  {String} tpl The string template containing the keys
       * @param  {Mixed}  obj The object containing the template keys
       * @return {String}     The updated string template
       */
      format = function(tpl, obj){
        if(typeof(tpl) !== 'string')
          return;

        return tpl.replace(/\{(\w+)\}/g, function(match, key){
          return obj[key] || '';
        });
      },
      /**
       * Returns the duration for the animation effect
       * @param  {Mixed}  duration The number or string containing the duration of the animation
       * @return {String} returns  The duration in string format
       */
      runtime = function(duration, defaut){
        if(duration){
          if(typeof(duration) === 'number')
            return duration + 'ms';

          if(typeof(duration) === 'string')
            return (duration.match(/[\d\.]*m?s/)[0] || defaut);
        }

        return defaut;
      },
      wait = function(duration, delay){
        var map = { ms: 1, s: 1000 },
            calc;

        calc = function(time){
          var match = time.match(/(\d+)(ms|s)/);
          return parseFloat(RegExp.$1) * map[RegExp.$2 || 's'];
        };

        return calc(duration) + calc(delay);
      };

  /**
   * Animates an object (or a group of them) using CSS3
   * @param {String}   effect The name of animation to apply
   * @param {Mixed}    config The animation configuration
   * @param {Function} fn     The animation completion callback (optional)
   */
  $.fn.effect = function(effect, config, fn){

    if($.isFunction(config)){
      fn = config;
      config = {};
    }

    config = $.extend(true, {
      bubbles: false,
      delay: '0s',
      direction: 'normal',
      duration: '1s',
      fillMode: 'forwards',
      iterationCount: '1',
      rule: null,
      timingFunction: 'ease'
    }, config || {}, $(this).data());

    return this.each(function(){
      return new effects(effect, config, this, fn);
    });
  };

  var effects = function(type, config, target, fn){
    return this.run(type, config, target, fn);
  };

  $.extend(effects.prototype, {
    /**
     * Generates a new animation rule in case it hadn't been cached previously
     * Developers can generate new rules just by using a name that doesn't match with
     * any of the default names and adding a new rule in "config.rule".
     *
     * @param  {String} name    The name of animation to use
     * @param  {Mixed}  config  The animation configuration
     * @return {String} returns The name of the rule to apply to the object(s) to be animated
     */
    rule: function(name){
      // check if rule already exists in our cache
      if(!cache[name]){
        // create browser specific keyframe animation and insert into cache
        cache[name] = '@' + prefix + 'keyframes ' + name;
        cache[name] += ' { ' + (
          format($.effect[name] || this.config.name, { browser: prefix })
        ) + '}';

        // add animation name to our inline style block so we only load it once
        style.textContent += ('\n' + cache[name]);
      }

      return name;
    },
    /**
     * Apply a given animation to one or more elements in a matched set
     * @param  {String}       type   The type of animation
     * @param  {Object}       config The animation configuration
     * @param  {HTML Element} target The HTML element to animate
     * @param  {Function}     fn     The animation completion callback
     * @return {HTML Element}
     */
    run: function(type, config, target, fn){
      var element = $(target),
          animation = null,
          animationEnd = { webkit: 'webkitAnimationEnd', moz: 'animationend', o: 'oAnimationEnd', ms: 'animationend' },
          prev = element.css(prefix + 'animation-name'),
          css = {};

      // reference config
      this.config = config;
      // make sure we have our style block ready
      createStyle();
      // setup callback method
      element.one(animationEnd[cleaned], function(e){
        if(!config.bubbles)
          e.stopPropagation();

        element.css(prefix + 'animation-play-state', 'paused');

        $.isFunction(fn) && fn.call(this);
      });

      if(type === 'reset'){
        element.css(prefix + 'animation', 'none');
      }else{
        config = config || {};
        animation = this.rule(type, config);

        // reset animation state for reuse
        if(type === prev){
          element.css(prefix + 'animation', 'none');

          setTimeout(function(){
            css[prefix + 'animation-name'] = animation;
          }, 10);
        }else{
          css[prefix + 'animation-name'] = animation;
        }

        css[prefix + 'animation-delay']           = runtime(config.delay, '0s');
        css[prefix + 'animation-direction']       = config.direction;
        css[prefix + 'animation-duration']        = runtime(config.duration, '1s');
        css[prefix + 'animation-fill-mode']       = config.fillMode;
        css[prefix + 'animation-iteration-count'] = config.iterationCount;
        css[prefix + 'animation-play-state']      = config.playState || 'running';
        css[prefix + 'animation-timing-function'] = config.timingFunction;
        css[prefix + 'tranform']                  = 'translateZ(0)';

        // apply styling to element
        element.css(css) && (css = null);
      }

      return target;
    }
  });


  $.fn.transform = function(config, duration, fn){
    config = $.extend(true, {
      duration: '500ms'
    }, config, $(this).data());

    if($.isFunction(duration)){
      fn = duration;
      duration = config.duration;
    }

    return this.each(function(){
      return new transform(this, config, duration, fn);
    });
  };

  var transform = function(element, config, duration, fn){
    var easing = config.easing || 'linear',
        duration = runtime(duration, '500ms'),
        delay = runtime(config.delay, '0s');

    this.run($(element), config, duration, delay, easing, fn);
  };

  $.extend(transform.prototype, {
    reset: function(){
      return reset[prefix + 'transition-delay'] = reset[prefix + 'transition-duration'] = reset[prefix + 'transition-property'] = '';
    },
    run: function(element, config, duration, delay, easing, callback){

      var $t = this,
          css = {},
          cssTransforms = [],
          cssTransitions = [],
          timeout = wait(duration, delay),
          fn, property, sleep, value;

      for(property in config){
        if(!properties.test(property)){
          if(transforms.test(property)){
            cssTransforms.push(property + '(' + config[property] + ')');
          }else{
            if((/^(?:(-|\+)(?:=))/).test(config[property])){
              var direction = RegExp.$1,
                  number = parseFloat(String(config[property]).replace(/\+|-|=/g, '')),
                  current = parseFloat(element.css(property)) || 0;

              value = !!~direction.indexOf('+') ? current + number : current - number;
            }else{
              value = config[property];
            }

            css[property] = value;

            cssTransitions.push(property);
          }
        }
      }

      css[prefix + 'transition-delay']           = delay;
      css[prefix + 'transition-duration']        = duration;
      css[prefix + 'transition-property']        = cssTransitions.join(' ');
      css[prefix + 'transition-timing-function'] = easing;
      css[prefix + 'transform']                  = 'translateZ(0) ' + cssTransforms.join(' ');

      element.css(css) && (css = null) && (cssTransforms = cssTransitions = []);

      fn = function(e){
        return typeof(e) !== 'undefined' && e.target !== e.originalTarget ? false : $(e.target).unbind('.transform');
      };

      element.on(animationEnd[cleaned] + '.transform', fn);

      sleep = setTimeout(function(){
        element.css($t.reset());
        $.isFunction(callback) && callback.call(element[0]);

        sleep && clearTimeout(sleep) && (sleep = null);
      }, timeout);
    }
  });


  $.extend($.effect, {
    scrolling: {
      cards: '.cards { {browser}perspective: 300px; perspective: 300px; {browser}perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .cards {cls} { {browser}transition: all 600ms ease; {browser}transform-origin: 100% 50%; transform-origin: 100% 50%; } .cards {cls}.past { {browser}transform: translate3d( 0, -100px, -100px ) rotateX( -90deg ); transform: translate3d( 0, -100px, -100px ) rotateX( -90deg ); } .cards {cls}.future { {browser}transform: translate3d( 0, 100px, -100px ) rotateX( 90deg ); transform: translate3d( 0, 100px, -100px ) rotateX( 90deg ); }',
      curl: '.curl{-webkit-transform: translateZ(0); -webkit-perspective:600px;-moz-perspective:600px;-ms-perspective:600px;-o-perspective:600px;perspective:600px;-webkit-perspective-origin:0 50%;-moz-perspective-origin:0 50%;-ms-perspective-origin:0 50%;-o-perspective-origin:0 50%;perspective-origin:0 50%}.curl {cls}{-webkit-transition:all 600ms ease,opacity 200ms ease;-moz-transition:all 600ms ease;-ms-transition:all 600ms ease,opacity 200ms ease;-o-transition:all 600ms ease,opacity 200ms ease;transition:all 600ms ease,opacity 200ms ease;-webkit-transform-origin:0 0;-moz-transform-origin:0 0;-ms-transform-origin:0 0;-o-transform-origin:0 0;transform-origin:0 0;-webkit-backface-visibility:hidden;-moz-backface-visibility:hidden;-ms-backface-visibility:hidden;-o-backface-visibility:hidden;backface-visibility:hidden}.curl {cls}.past{opacity:0; -webkit-transform: translateZ(0); -webkit-transform:rotateY(90deg);-moz-transform:rotateY(90deg);-ms-transform:rotateY(90deg);-o-transform:rotateY(90deg);transform:rotateY(90deg)}.curl {cls}.future{opacity:0;-webkit-transform:rotateY(90deg);-moz-transform:rotateY(90deg);-ms-transform:rotateY(90deg);-o-transform:rotateY(90deg);transform:rotateY(90deg)}',
      fader: '.fader {cls} { {browser}transition: opacity .35s ease-in-out; } .fader {cls}.past { opacity: 0; } .fader {cls}.future { opacity: 0; }',
      fan: '.fan {cls} { {browser}transition: all 600ms cubic-bezier(0.390, 0.575, 0.565, 1.000); {browser}transform-origin: 0% 0%; } .fan {cls}.past { {browser}transform: rotate( -60deg ); } .fan {cls}.future { {browser}transform: rotate( 70deg ); }',
      flip: '.flip { -webkit-perspective: 400px; -moz-perspective: 400px; -ms-perspective: 400px; -o-perspective: 400px; perspective: 400px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .flip {cls} { -webkit-transition: all 600ms ease, opacity 300ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 300ms ease; -o-transition: all 600ms ease, opacity 300ms ease; transition: all 600ms ease, opacity 300ms ease; -webkit-transform-origin: 0% 0%; -moz-transform-origin: 0% 0%; -ms-transform-origin: 0% 0%; -o-transform-origin: 0% 0%; transform-origin: 0% 0%; } .flip {cls}.past { opacity: 0; -webkit-transform-origin: 0% 100%; -moz-transform-origin: 0% 100%; -ms-transform-origin: 0% 100%; -o-transform-origin: 0% 100%; transform-origin: 0% 100%; -webkit-transform: rotateX( 80deg ); -moz-transform: rotateX( 80deg ); -ms-transform: rotateX( 80deg ); -o-transform: rotateX( 80deg ); transform: rotateX( 80deg ); } .flip {cls}.future { opacity: 0; -webkit-transform: rotateX( -80deg ); -moz-transform: rotateX( -80deg ); -ms-transform: rotateX( -80deg ); -o-transform: rotateX( -80deg ); transform: rotateX( -80deg ); }',
      fly: '.fly { -webkit-perspective: 2000px; -moz-perspective: 2000px; -ms-perspective: 2000px; -o-perspective: 2000px; perspective: 2000px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .fly {cls} { -webkit-transition: all 600ms ease, opacity 300ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 300ms ease; -o-transition: all 600ms ease, opacity 300ms ease; transition: all 600ms ease, opacity 300ms ease; -webkit-transform-origin: 50% 50% -50px; -moz-transform-origin: 50% 50% -50px; -ms-transform-origin: 50% 50% -50px; -o-transform-origin: 50% 50% -50px; transform-origin: 50% 50% -50px; } .fly {cls}.past { opacity: 0; -webkit-transform: rotateX( -180deg ); -moz-transform: rotateX( -180deg ); -ms-transform: rotateX( -180deg ); -o-transform: rotateX( -180deg ); transform: rotateX( -180deg ); } .fly {cls}.future { opacity: 0; -webkit-transform: rotateX( 180deg ); -moz-transform: rotateX( 180deg ); -ms-transform: rotateX( 180deg ); -o-transform: rotateX( 180deg ); transform: rotateX( 180deg ); }',
      grow: '.grow {cls}{ {browser}transition: all 600ms ease; {browser}transform-origin: 50% 50%; } .grow {cls}.past { {browser}transform: scale( 0.01 ); } .grow {cls}.future {{browser}transform: scale( 0.01 ); }',
      helix: '.helix{-webkit-perspective:600px;-moz-perspective:600px;-ms-perspective:600px;-o-perspective:600px;perspective:600px;-webkit-perspective-origin:50% 50%;-moz-perspective-origin:50% 50%;-ms-perspective-origin:50% 50%;-o-perspective-origin:50% 50%;perspective-origin:50% 50%}.helix {cls}{-webkit-transition:all 600ms ease,opacity 200ms ease;-moz-transition:all 600ms ease;-ms-transition:all 600ms ease,opacity 200ms ease;-o-transition:all 600ms ease,opacity 200ms ease;transition:all 600ms ease,opacity 200ms ease;-webkit-transform-origin:50% 50%;-moz-transform-origin:50% 50%;-ms-transform-origin:50% 50%;-o-transform-origin:50% 50%;transform-origin:50% 50%}.helix {cls}.past{opacity:0;-webkit-transform:rotateY(180deg);-moz-transform:rotateY(180deg);-ms-transform:rotateY(180deg);-o-transform:rotateY(180deg);transform:rotateY(180deg)}.helix {cls}.future{opacity:0;-webkit-transform:rotateY(-180deg);-moz-transform:rotateY(-180deg);-ms-transform:rotateY(-180deg);-o-transform:rotateY(-180deg);transform:rotateY(-180deg)}',
      papercut: '.papercut { {browser}perspective: 600px; {browser}perspective-origin: 0% 0%; } .papercut {cls} { {browser}transition: all 600ms ease; {browser}transform-origin: 0% 0%; } .papercut {cls}.past { {browser}transform: skewY( -30deg ); } .papercut {cls}.future { {browser}transform: skewY( 30deg ); }',
      slide: '.slide {cls} { {browser}transition: all 600ms cubic-bezier(0.260, 0.860, 0.440, 0.985); } .slide {cls}.past { {browser}transform: translateX( -70% ); } .slide {cls}.future { {browser}transform: translateX( -70% ); }',
      twirl: '.twirl { -webkit-perspective: 400px; -moz-perspective: 400px; -ms-perspective: 400px; -o-perspective: 400px; perspective: 400px; -webkit-perspective-origin: 50% 50%; -moz-perspective-origin: 50% 50%; -ms-perspective-origin: 50% 50%; -o-perspective-origin: 50% 50%; perspective-origin: 50% 50%; } .twirl {cls} { -webkit-transition: all 600ms ease, opacity 200ms ease; -moz-transition: all 600ms ease; -ms-transition: all 600ms ease, opacity 200ms ease; -o-transition: all 600ms ease, opacity 200ms ease; transition: all 600ms ease, opacity 200ms ease; -webkit-transform-origin: 50% 50%; -moz-transform-origin: 50% 50%; -ms-transform-origin: 50% 50%; -o-transform-origin: 50% 50%; transform-origin: 50% 50%; } .twirl {cls}.past { opacity: 0; -webkit-transform: rotate3d( 80,-70,10,180deg ); -moz-transform: rotate3d( 80,70,10,180deg ); -ms-transform: rotate3d( 80,70,10,180deg ); -o-transform: rotate3d( 80,70,10,180deg ); transform: rotate3d( 80,70,10,180deg ); } .twirl {cls}.future { opacity: 0; -webkit-transform: rotate3d( 80,70,10,-180deg ); -moz-transform: rotate3d( 80,70,10,-180deg ); -ms-transform: rotate3d( 80,70,10,-180deg ); -o-transform: rotate3d( 80,70,10,-180deg ); transform: rotate3d( 80,70,10,-180deg ); }',
      zipper: '.zipper {cls} { {browser}transition: all 600ms cubic-bezier(0.390, 0.575, 0.565, 1.000); {browser}transform-origin: 50% 0%; } .zipper {cls}.past:nth-child(odd), .zipper {cls}.future:nth-child(odd) { {browser}transform: translateX( 80% ); } .zipper {cls}.past:nth-child(even), .zipper {cls}.future:nth-child(even) { {browser}transform: translateX( -80% ); }'
    }
  });

  /**
   * Animates a containers child elements using CSS3 animations
   * @param {String}   type   The name of animation to use
   * @param {Mixed}    config Extra params to config the animation
   * @param {Function} fn     The animation completion callback (optional)
   */
  $.fn.animateScroll = function(type, config){

    if(typeof(type) === 'object')
      (config = type) && (type = false);

    config = $.extend({}, config || {}, $(this).data());

    return this.each(function(){
      var element = $(this),
          instance = element.data('animateScroll');

      return instance ? element : element.data('animateScroll', new animateScroll(type, config, this));
    });
  };

  var animateScroll = function(type, config, container){

    this.config = config;
    this.config.type = type || this.config.type || 'grow';

    this.container = $(container);
    this.container
      .addClass(this.config.type)
      .css('translateZ', '0');

    supportsTouch && this.touch();

    this.container.addClass('animate-scroll')
    .height(this.config.height || this.container.css('height') || 'auto');

    this.setup();
    createStyle();
    this.rule(this.config.type);

    this.active = true;
    this.refresh();
  };

  $.extend(animateScroll.prototype, {

    end: function(e){
      var distanceMoved = this.touch.start - this.touch.value;

      if(!this.touch.isAccellerating){
        this.velocity = (this.touch.start - this.touch.value) / 10;
      }

      if(Date.now() - this.touch.lastMove > 200 || Math.abs(this.touch.previous - this.touch.value) < 5){
        this.velocity = 0;
      }

      this.top.value += this.touch.offset;

      this.touch.offset = 0;
      this.touch.start = 0;
      this.touch.value = 0;
      this.touch.isActive = false;
      this.touch.isAccellerating = false;

      this.touch.accellerateTimeout && clearInterval(this.touch.accellerateTimeout);

      if(Math.abs(this.velocity) > 4 || Math.abs(distanceMoved) > 10){
        e.preventDefault();
      }
    },

    listen: function(){
      this.container.on('touchstart', $.proxy(this.start, this))
      .on('touchmove', $.proxy(this.move, this))
      .on('touchend', $.proxy(this.end, this));
    },

    move: function(e){
      if(e.touches.length === 1 ){
        var previous = this.touch.value;

        this.touch.value = e.touches[0].clientY;
        this.touch.lastMove = Date.now();

        var sameDirection = (this.touch.value > this.touch.previous && this.velocity < 0) || (this.touch.value < this.touch.previous && this.velocity > 0);

        if(this.touch.isAccellerating && sameDirection){
          clearInterval( this.touch.accellerateTimeout );
          this.velocity += ( this.touch.previous - this.touch.value ) / 10;
        }
        else {
          this.velocity = 0;

          this.touch.isAccellerating = false;
          this.touch.offset = Math.round(this.touch.start - this.touch.value);
        }

        this.touch.previous = previous;
      }
    },

    refresh: function(){
      if(this.active){
        requestAnimFrame($.proxy(this.refresh, this));
        this.update();
      }
    },

    rule: function(name){
      if(!cache[name]){
        var rule = format($.effect.scrolling[name], { browser: prefix, cls: '.animate-scroll-item' });

        cache[name] = rule;
        style.textContent += ('\n' + cache[name]);
      }

      return name;
    },

    setup: function(){
      var $t = this,
           items = this.items = this.container.children();

      this.listHeight = this.container[0].offsetHeight;

      var item;

      items.each(function(index, element){
        element._offsetHeight = element.offsetHeight;
        element._offsetTop = element.offsetTop;
        element._offsetBottom = element._offsetTop + element._offsetHeight;
        element._state = '';
        element.classList.add('animate-scroll-item');

        item = element;

        if(supportsTouch && $t.config.type !== 'fader')
          element.style.opacity = 1;

      });

      this.tag = item.tagName.toLowerCase() || 'li';

      if(supportsTouch){
        this.top.natural = this.container[0].scrollTop;
        this.top.value = this.top.natural;
        this.top.max = item._offsetBottom - this.listHeight;
      }

      this.update(true);

      if(supportsTouch)
        this.listen();

    },

    start: function(e){
      e.preventDefault();

      if(e.touches.length === 1){
        this.touch.isActive = true;
        this.touch.start = e.touches[0].clientY;
        this.touch.previous = this.touch.start;
        this.touch.value = this.touch.start;
        this.touch.offset = 0;

        if(this.velocity){
          this.touch.isAccellerating = true;

          var scope = this;

          this.touch.accellerateTimeout = setTimeout(function(){
            scope.touch.isAccellerating = false;
            scope.velocity = 0;
          }, 500);
        }
        else {
          this.velocity = 0;
        }
      }
    },

    touch: function(){

      this.container.css('overflow', 'hidden');

      this.top = {
        value: 0,
        natural: 0
      };

      this.touch = {
        value: 0,
        offset: 0,
        start: 0,
        previous: 0,
        lastMove: Date.now(),
        accellerateTimeout: -1,
        isAccellerating: false,
        isActive: false
      };

      this.velocity = 0;

    },

    update: function(force){
      var scrollTop = supportsTouch ? this.top.value + this.velocity + this.touch.offset : (this.container[0].pageYOffset || this.container[0].scrollTop),
          scrollBottom = scrollTop + this.listHeight;

      if(supportsTouch){
        if(this.velocity || this.touch.offset){

          this.container[0].scrollTop = scrollTop;
          scrollTop = Math.max(0, Math.min(this.container[0].scrollTop, this.top.max));
          this.top.value = scrollTop - this.touch.offset;
        }

        if(!this.touch.isActive || this.touch.isAccellerating){
          this.velocity *= 0.95;
        }

        if(Math.abs(this.velocity) < 0.15){
          this.velocity = 0;
        }
      }

      if(supportsTouch && scrollTop !== this.top.natural || !scrollTop !== this.last || force){
        if(supportsTouch){
          this.top.natural = scrollTop;
          this.top.value = scrollTop - this.touch.offset;
        }

        this.last = scrollTop;

        this.items.each(function(){
          var item = this;

          if(item._offsetBottom < scrollTop){
            item._state !== 'past' && (item._state = 'past') && item.classList.add('past');
          }else if( item._offsetTop > scrollBottom){
            item._state !== 'future' && (item._state = 'future') && item.classList.add('future');
          }else if(item._state){
            item._state === 'past' && item.classList.remove('past');
            item._state === 'future' && item.classList.remove('future');
            item._state = '';
          }
        });
      }
    }
  });

  window.requestAnimFrame = (function(){
    return window.requestAnimationFrame || window[cleaned + 'RequestAnimationFrame'] || function(fn){
      window.setTimeout(fn, 1000 / 60);
    };
  })();

})(window, jQuery);

