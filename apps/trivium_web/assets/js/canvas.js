const Canvas = {
  mounted() {
    var canvas = this.el;
    var context = canvas.getContext("2d");

    var radius = 10;
    var dragging = false;

    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;

    canvas.lineWidth = radius*2;

    var putPoint = function(e) {
      if (dragging) {
        context.lineTo(e.offsetX, e.offsetY);
        context.stroke();
        context.beginPath();
        context.arc(e.offsetX, e.offsetY, radius, 0, Math.PI*2);
        context.fill();
        context.beginPath();
        context.moveTo(e.offsetX, e.offsetY);
      }
    }

    var engage = function(e) {
      dragging = true;
      putPoint(e)
    }

    var disengage = function() {
      dragging = false;
      context.beginPath();
    }

    // pointer
    canvas.addEventListener('mousedown', engage);
    canvas.addEventListener('mousemove', putPoint);
    canvas.addEventListener('mouseup', disengage);

    // touch
    canvas.addEventListener('touchstart', engage);
    canvas.addEventListener('touchmove', putPoint);
    canvas.addEventListener('touchend', disengage);

    var setRadius = function(newRadius) {
      if (newRadius < minRad) {
        newRadius = minRad;
      } else if (newRadius > maxRad) {
        newRadius = maxRad;
      }

      radius = newRadius;
      canvas.lineWidth = radius*2;

      radSpan.inneHTML = radius;
    }

    var minRad = 0.5,
        maxRad = 100,
        defaultRad = 20,
        radInterval = 5,
        radSpan = document.getElementById('radval'),
        decRad = document.getElementById('decrad'),
        incRad = document.getElementById('incrad');

    decRad.addEventListener('click', function() {
      setRadius(radius - radInterval);
      console.log("Dec", radius);
    });

    incRad.addEventListener('click', function() {
      setRadius(radius + radInterval);
      console.log("Inc", radius);
    });

    setRadius(defaultRad);

    var colors = ['black', 'grey', 'crimson', 'orange', 'yellow', 'indigo', 'lime', 'violet'];

    for (var i = 0; i < colors.length; i++) {
      var swatch = document.createElement('div');
      swatch.className = 'swatch';
      swatch.style.backgroundColor = colors[i];
      swatch.addEventListener('click', setSwatch);
      document.getElementById('colors').appendChild(swatch);
    }

    function setColor(color) {
      context.fillStyle = color;
      context.strokeStyle = color;
      var active = document.getElementsByClassName('active')[0];
      if (active) {
        active.className = 'swatch';
      }
    }

    function setSwatch(e) {
      // identify swatch
      var swatch = e.target
      // set color
      setColor(swatch.style.backgroundColor);
      // give active status
      swatch.className += ' active';
    }
    //document.getElementsByClassName('active')[0]
    // setSwatch({target: "a"})
  }
}

export default Canvas
