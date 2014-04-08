var mapOptions = {
  center: new google.maps.LatLng(33.7677129, -84.420604),
  zoom: 12

};
var map, me, pusher;
var nodes = {};

$(document).ready( function () {
    pusher = new Pusher(pusher_key, { authEndpoint: '/users/pusher_auth' });
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

    if(navigator.geolocation)
        navigator.geolocation.getCurrentPosition(showPosition);

    var fleetChannel = pusher.subscribe('presence-fleet_'+fleet_id);

    fleetChannel.bind('pusher:subscription_succeeded', function(members) {
      console.log("success");
    });

    fleetChannel.bind('pusher:subscription_error', function(status) {
            alert("Error!\n"+status);
    });

    fleetChannel.bind('pusher:subscription_succeeded', function(members) {
            members.each(function(member) {
                    addMember(member);
            });
    });

    fleetChannel.bind('pusher:member_added', function(member) {
      addMember(member);
    });

    //WS.subscribe("nodes:camera", function(channel, node, data) {
    //    console.log("new camera frame");
    //    document.getElementById('camera').setAttribute('src', 'data:image/jpg;base64,' + data);
    //});

    //WS.subscribe("notifications", function(channel, node, data) {
    //    console.log("MSG from " + node + ": "+data);
    //});
    //
    $("button#all").click(function () {
        WS.publish("notifications:all", $("input#message").val());
    });
});

function addMember(member) {
                if(member.id.indexOf('-') != -1){
                    device = member.id.split('-')[1]
                    if(nodes[device] == null){
                        nodes[device] = new Device(pusher, device, member);
                    }
                }
}

function showPosition(position) {
    var myPos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    map.panTo(myPos);
    if(me != null)
        me.setMap(null);

    me = new google.maps.Marker({
       position: myPos,
       map: map,
       title: "Me",
       animation: google.maps.Animation.DROP
    });
    var infowindow = new google.maps.InfoWindow({
   			content: "My location"
	});
    google.maps.event.addListener(me, 'click', function(){
    	infowindow.open(map,this);
    });
}
