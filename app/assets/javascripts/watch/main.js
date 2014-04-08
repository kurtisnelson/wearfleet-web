var mapOptions = {
  center: new google.maps.LatLng(33.7677129, -84.420604),
  zoom: 12

};
var map, me, pusher;
var nodes = {};
var onlineCount = 0;
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
            updateOnlineCount(members.count);
            members.each(function(member) {
                    addMember(member);
            });
    });

    fleetChannel.bind('pusher:member_added', function(member) {
            addMember(member);
            updateOnlineCount(onlineCount + 1);
    });

    fleetChannel.bind('pusher:member_removed', function(member) {
            updateOnlineCount(onlineCount - 1);
    });

    $("#chat button").click(function() {
            var msg = $("#chat input[name=message]").val();
            console.log(msg);
            fleetChannel.trigger('client-all', {'message': msg});
    });

    fleetChannel.bind('client-all', addMessage);
    fleetChannel.bind('client-dispatch', addMessage);
    fleetChannel.bind('dispatch', addMessage);
    fleetChannel.bind('all', addMessage);

    //WS.subscribe("nodes:camera", function(channel, node, data) {
    //    console.log("new camera frame");
    //    document.getElementById('camera').setAttribute('src', 'data:image/jpg;base64,' + data);
    //});
});

function addMessage(data) {
    $("#chat #room").append("<li>" + data.message + "</li>");
}

function addMember(member) {
                if(member.id.indexOf('-') != -1){
                    device = member.id.split('-')[1]
                    if(nodes[device] == null){
                        nodes[device] = new Device(pusher, device, member);
                    }
                }
}

function updateOnlineCount(c) {
  onlineCount = c;
  $("#chat .count").text(c);
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
