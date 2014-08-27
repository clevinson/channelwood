var segLength = 15;
var numLines = 150;
var lineDepth = 200;
var raster = null;
var lines = new Array(numLines)
var shapeSegments = []
var wing_length = 20;
var wingSegments = []
var time = 0;

var pathSettings = {
  strokeColor: '#555',
  closed: false,
  strokeWidth: 1.5
}

// As the web is asynchronous, we need to wait for the raster to
// load before we can perform any operation on its pixels.
new Raster('img/wip-logo.png').on('load', function() {
  raster = this;
  this.remove();
  drawRect();
  offsetShape();
});

function tick() {
  time += 1;
}

function offsetShape() {
    for(var i=0; i < shapeSegments.length; i++){
      var seg = shapeSegments[i].segment;
      shapeSegments[i].maxY = seg.point.y + 1.5*(Math.random() - 0.5);
      shapeSegments[i].zeroY = seg.point.y;

      seg.point.y = shapeSegments[i].maxY;
    }
}

function foo(x) {
  if(x < 2*Math.PI) {
    return -1*Math.cos(x) + 1;
  } else {
    return 0;
  }
}

function runShape(t) {
  if(raster){
    for(var i=0; i < shapeSegments.length; i++){
      var seg = shapeSegments[i];
      seg.segment.point.y = seg.zeroY + foo(t/80)*(seg.maxY - seg.zeroY);
    }
  }
}


function onFrame(event) {
  tick();
  runShape(time);
  jellyWings();
}

function jellyWings(){
  for(var i=0; i < wingSegments.length; i++){
    var seg = wingSegments[i];
    seg.point.x = seg.point.x + 0.5*(Math.random() - 0.5);
  }
}

function drawRect() {
  raster.fitBounds(view.bounds);
  raster.scale(0.9);

  for(var j=0; j < numLines; j++) {
    lines[j] = new Path(pathSettings);

    var y_final;
    var y_init;

    var y = raster.bounds.y + j*raster.bounds.height/numLines;
    for(var i=0; i < raster.bounds.width/segLength; i++) {
      var x = raster.bounds.x + i*segLength;

      var position = new Point(x,y);
      if(raster.bounds.contains(position)){
        color = raster.getAverageColor(position);
      }else{
        color = 1;
      }
      var offset = 0;//(1 - color.gray) * lineDepth;
      lines[j].add(new Point(x, y + offset));
      if(color && (color.gray < 0.6)){
        shapeSegments.push({segment: lines[j].lastSegment});
        //shapeMaxes.push(color.gray);
      }
      if(i == 0){
        y_init = y + offset;
      }
      y_final = y + offset;
    }

    var x_final = raster.bounds.x + raster.bounds.width + 5 + wing_length*Math.random();
    lines[j].add(new Point(x_final, y_final));

    var x_init = raster.bounds.x - 5 - wing_length*Math.random();
    lines[j].insert(0,new Point(x_init, y_init));

    wingSegments.push(lines[j].firstSegment);
    wingSegments.push(lines[j].lastSegment);

    lines[j].smooth();
  }

}