function js_ready(){
$(function() {

  $('.login').click(function(){
    FB.login(function(){}, {scope : 'user_groups,offline_access'})
    return false
  })

  $('.groups a').live('click', function(){
    var a = $(this)
    var gid = a.attr('rel')
    $('.actions').maskedload('/stats/group/'+gid, function(){
      $('.actions table').flexigrid({
        height: 'auto',
        colModel : [
      		{display: 'Имя', name : 'name', width : 120, sortable : true, align: 'left'},
      		{display: 'Топик', name : 'topic', width : 230, sortable : true, align: 'left'},
      		{display: 'Действие', name : 'action', width : 80, sortable : true, align: 'left'},
      		{display: 'Сообщение', name : 'message', width : 280, align: 'left'},
      		{display: 'Время', name : 'time', width : 170, sortable : true, align: 'right'}
      		],
	      searchitems : [
		      {display: 'Топик', name : 'topic'},
		      {display: 'Имя', name : 'name', isdefault: true}
	      	],
	      sortname: "time",
      	sortorder: "asc",
      	usepager: true//,
      	//useRp: true,
      	//rp: 15
      })
      a.siblings().removeClass('active')
      a.addClass('active')

    })
    return false
  })

})
}

function facebook_auth(response) {
  if (response.authResponse) {
    var uid = response.authResponse.userID;
    var token = response.authResponse.accessToken;
    $.get("/auth/facebook?token="+token+"&uid="+uid, function(data, status){
      $('.loggingin').removeClass('loggingfb')
      if(status == 'success'){
        $('#logins .fb').append($('<span>'+data+'</span>'))
        $('body').addClass('loggedinfb')

        $('.groups').maskedload('/stats/groups')
      }
    })
  } else
    $('.loggingin').removeClass('loggingfb')
}
