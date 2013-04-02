$(function(){

  window.prettyPrint && prettyPrint();

  var effectOptions = $('#effects-group input'),
      header = $('#header'),
      nav = $('#nav li'),
      selected = true,
      toggle = function(state){
        return effectOptions.prop('checked', state) && (selected = state);
      };

  $('h1', header).effect('slideInLeft');
  $('ul', header).effect('slideInRight');

  header.effect('fadeInDownBig', function(){
    $('#content').effect('fadeIn');
  });

  $('#effects button').each(function(){
    $(this).on('click', function(){
      var img = $(this).closest('.shazam').find('.html-badge'),
          effect = $(this).data('effect');

      img.effect(effect, function(){
        $(this).effect('reset');
      });
    });
  });

  $('#animate-box').on('click', function(){
    $('#size-box').transform({ left: '-=100', top: '+=' + 60, opacity: 1, width: '+=' + 500, height: 200 }, '1s', function(){
      $('#size-box').transform({ left: '+=100', top: '-=' + 60, width: '+=' + 100, height: 100, delay: 500}, 1000, function(){
        $('#size-box').transform({ left: '-=100', top: '+=' + 60, width: '-=' + 200, height: 50}, 1000, function(){
          $('#size-box').transform({ left: '-=100', top: '+=' + 60, opacity: 1, width: '+=' + 500, height: 500 }, 1000, function(){
            $('#size-box').transform({ left: '50', top: 40, width: 200, height: 100}, 1500, function(){
              $('#size-box').transform({ left: 40, top: 100, width: 200, height: 50}, 1500);
            });
          });
        });
      });
    });
  });

  $('#twist-box').on('click', function(){
    $('#boxer').transform({ rotateZ: '45deg', translate3d: '0, 10px,0' }, null, function(){
      $('#boxer').transform({ rotateZ: '0deg', opacity: '.5', width: '+=100px', translate3d: '0, 10px,0'}, null, function(){
        $('#boxer').transform({ scale: '2', opacity: '1', rotate: '360deg', width: '-=50px'}, null, function(){
          $('#boxer').transform({ scale: '1', opacity: '1', rotate: '180deg', width: '+=100px'}, null, function(){
            $('#boxer').transform({ translate3d: '10px, 10px,0', rotate: '0deg', width: 100, height: 100}, null, function(){
            });
          });
        });
      });
    });
  });

  $('a', nav).on('click', function(e){
    nav.removeClass('active');
    $(this).parent().addClass('active');
  });

  $('#toggle').on('click', function(){
    return toggle(selected ? false : true);
  });

  $('#effects-cb').on('change', function(){
    return toggle(this.checked ? true : false);
  });
});
