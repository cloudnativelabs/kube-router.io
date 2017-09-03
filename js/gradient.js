// Original script by Mario Klingemann. View at https://codepen.io/quasimondo/pen/lDdrF.
// Adapted for use by Kube Router
// Octopi change colors... :)
  var colors = new Array(
    [154,229,230], //darker sky blue
    [168,294,255], //sky blue
    //[129,160,148], //murky green
    [112,202,209], //blue between first two
    [147,190,223], //pastel purple
    //[254,95,85], //coral
    [170,250,200], //light green
    [17,157,164] //saturated teal

  )

  var step = 0;

  // COLOR TABLE INDICES FOR:
  //  - current color left
  //  - next color left
  //  - current color right
  //  - next color right
  var colorIndices = [0,1,2,3];

  // TRANSITION SPEED
  var gradientSpeed = 0.0002;

  // STRAIGHT UP MAGIC
  function updateGradient(){
    if ( $===undefined ) return;

    var c0_0 = colors[colorIndices[0]];
    var c0_1 = colors[colorIndices[1]];
    var c1_0 = colors[colorIndices[2]];
    var c1_1 = colors[colorIndices[3]];

    var istep = 1 - step;

    var r1 = Math.round(istep * c0_0[0] + step * c0_1[0]);
    var g1 = Math.round(istep * c0_0[1] + step * c0_1[1]);
    var b1 = Math.round(istep * c0_0[2] + step * c0_1[2]);

    var color1 = "rgb("+r1+","+g1+","+b1+")";

    var r2 = Math.round(istep * c1_0[0] + step * c1_1[0]);
    var g2 = Math.round(istep * c1_0[1] + step * c1_1[1]);
    var b2 = Math.round(istep * c1_0[2] + step * c1_1[2]);

    var color2 = "rgb("+r2+","+g2+","+b2+")";

    $('.gradient').css({
      background: "-webkit-gradient(linear, bottom right, from("+color1+"), to("+color2+"))"
    }).css({
      background: "moz-linear-gradient(bottom right, "+color1+" 0%, "+color2+" 100%)"
    }).css({
      background: "linear-gradient(to bottom right, "+color1+", "+color2+")"});

    step += gradientSpeed;
    if ( step >= 1 ){
      step %= 1;
      colorIndices[0] = colorIndices[1];
      colorIndices[2] = colorIndices[3];

      // Pick two new target color indicies
      // Do not pick the same as the current one
      colorIndices[1] = ( colorIndices[1] + Math.floor(1 + Math.random() * (colors.length - 1))) % colors.length
      colorIndices[3] = ( colorIndices[3] + Math.floor(1 + Math.random() * (colors.length - 1))) % colors.length;
    }
  }

  setInterval(updateGradient, 10);
