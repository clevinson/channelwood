var segLength = 15;
var numLines = 175;
var lineDepth = 6;
var raster = null;
var lines = new Array(numLines)
var shapeSegments = []
var wing_length = 20;
var wingSegments = []

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
  jellyWings()
}

function jellyWings(){
  for(var i=0; i < wingSegments.length; i++){
    var seg = wingSegments[i];
    seg.point.x = seg.point.x + 0.7*(Math.random() - 0.5);
  }
}

function drawRect() {
  raster.fitBounds(view.bounds);
  raster.scale(0.85);

  for(var j=0; j < numLines; j++) {
    lines[j] = new Path({
      strokeColor: '555',
      closed: false,
      strokeWidth: 1
    });

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
      var offset = (1 - color.gray) * lineDepth;
      lines[j].add(new Point(x, y + offset));
      if(color && (color.gray < 0.6)){
        shapeSegments.push(lines[j].lastSegment);
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
  console.log(wingSegments);

}