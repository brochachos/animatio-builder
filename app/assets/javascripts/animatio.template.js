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
 * @package   animatio.js - jQuery CSS3 Animations Plugin
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
     * Replaces template keys with object property values
     * @param  {String} tpl The string template containing the keys
     * @param  {Mixed}  obj The object containing the template keys
     * @return {String}     The updated string template
     */
    format: function(tpl, obj){
      if(typeof(tpl) !== 'string')
        return;

      return tpl.replace(/\{(\w+)\}/g, function(match, key){
        return obj[key] || '';
      });
    },
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
          this.format($.effect[name] || this.config.name, { browser: prefix })
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
          transforms = [],
          transitions = [],
          timeout = wait(duration, delay),
          fn, property, sleep, value;

      for(property in config){
        if(!(properties).test(property)){
          if((transforms).test(property)){
            transforms.push(property + '(' + config[property] + ')');
          }else{
            if((/^([-+=])/).test(config[property])){

              var direction = RegExp.$1,
                  number = parseInt(String(config[property]).replace(/[-=+]/g, ''), 10),
                  current = element.css(property) || 0;

              value = !!~direction.indexOf('+') ? current + number : current - number;
            }else{
              value = config[property];
            }

            css[property] = value;

            transitions.push(property);
          }
        }
      }

      css[prefix + 'transition-delay']           = delay;
      css[prefix + 'transition-duration']        = duration;
      css[prefix + 'transition-property']        = transitions.join(' ');
      css[prefix + 'transition-timing-function'] = easing;
      css[prefix + 'transform']                  = 'translateZ(0) ' + transforms.join(' ');

      element.css(css) && (css = null) && (transforms = transitions = []);

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

})(window, jQuery);
