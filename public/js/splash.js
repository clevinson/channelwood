// Please note: dragging and dropping images only works for
// certain browsers when serving this script online:

var segLength = 10;
var numLines = 150;
var lineDepth = 10;
var raster = null;
var lines = new Array(numLines)
var shapeSegments = []

// As the web is asynchronous, we need to wait for the raster to
// load before we can perform any operation on its pixels.
new Raster('img/wip-logo.png').on('load', function() {
  raster = this;
  this.remove();
  drawRect();
});

function onFrame(event) {
  if(raster){
    //var line = lines[Math.floor(Math.random()*numLines)];
    for(var i=0; i < shapeSegments.length; i++){
      var seg = shapeSegments[i];
      seg.point.y = seg.point.y + 0.3*(Math.random() - 0.5);
    }
  }
}

function drawRect() {
  raster.fitBounds(view.bounds);

  for(var j=0; j < numLines; j++) {
    lines[j] = new Path({
      strokeColor: 'black',
      closed: false
    });

    var y = raster.bounds.y + j*raster.bounds.height/numLines;
    for(var i=0; i < raster.bounds.width/segLength; i++) {
      var x = raster.bounds.x + i*segLength;

      var position = new Point(x,y);
      if(raster.bounds.contains(position)){
        color = raster.getAverageColor(position);
      }else{
        color = 1;
      }
      var offset = (1 - color.gray) * lineDepth;
      lines[j].add(new Point(x,y + offset));
      if(color && (color.gray < 0.6)){
        shapeSegments.push(lines[j].lastSegment);
      }
    }
    lines[j].smooth();
  }
  console.log(view.bounds);
}


function onResize() {
  //if (raster)
    //drawRect();
}