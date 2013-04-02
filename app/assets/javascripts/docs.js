$(function(){
  window.prettyPrint && prettyPrint();

  var header = $('#header');

  $('h1', header).effect('slideInLeft');
  $('ul', header).effect('slideInRight');

  header.effect('fadeInDownBig', function(){
    $('#content').effect('fadeIn');
  });

  $('#effects button').each(function(){
    $(this).on('click', function(){
      var img = $(this).closest('.shazam').find('.html-badge'),
          effect = $(this).data('effect');

      img.effect(effect, {}, function(){
        $(this).effect('reset');
      });
    });
  });

  $('#animate_box').on('click', function(){
    $('#animate_me').transform({ left: '-=100', top: '+=' + 60, opacity: 1, width: '+=' + 500, height: 200 }, '1s', function(){
      console.log('fired 1');
      $('#animate_me').transform({ left: '+=100', top: '-=' + 60, width: '+=' + 100, height: 100, delay: 500}, 1000, function(){
        console.log('fired 2');
        $('#animate_me').transform({ left: '-=100', top: '+=' + 60, width: '-=' + 200, height: 50}, 1000, function(){
          console.log('fired 3');
          $('#animate_me').transform({ left: '-=100', top: '+=' + 60, opacity: 1, width: '+=' + 500, height: 500 }, 1000, function(){
            console.log('fired 4');
            $('#animate_me').transform({ left: '50', top: 40, width: 200, height: 100}, 1500, function(){
              console.log('fired 5');
              $('#animate_me').transform({ left: 40, top: 100, width: 200, height: 50}, 1500, function(){
                console.log('fired 6');
              });
            });
          });
        });
      });
    });
  });

  $('#rotate_screen').on('click', function(){
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

  $('#nav li a').on('click', function(e){
    $('#nav li').removeClass('active');
    $(this).parent().addClass('active');
  });

  $('form').submit(function(e){
    e.preventDefault();
    var selected = [];

    $('input:checked', this).each(function(){
      if(this.value !== '')
        selected.push(this.value);
    });

    $.ajax({
      url: 'http://animatio.herokuapp.com/build',
      data: { animations: selected }
    });
  });
});
