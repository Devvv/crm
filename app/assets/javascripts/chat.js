
var chat = new Object();
chat.new_message_count = 0;
chat.me = {};

chat.user_list_create = function(id){
    var box =  $('.left_column').find('.overview');
    $.each(users, function(i,n){
        if(n.attributes.id == id && !$('.chat_box_user#'+n.attributes.id).get(0)){
            box.append(
                '<div class="chat_box_user" id="' + n.attributes.id + '">' +
                    '<div class="img_box">' +
                        '<img alt="' + n.attributes.email + '" height="40" src="' + n.attributes.photo_path_thumb + '" width="40">' +
                    '</div>' +
                    '<div class="name">' +
                        n.attributes.email +
                    '</div>' +
                '</div>'
            );
        }
        chat.contacts_list_show("hide");
        $('.chat_box_user#'+n.attributes.id).trigger('click');
    });
    $('.left_column').find('.viewport').tinyscrollbar_update();
    chat.users_list_click();
}
chat.users_list_click = function(act){
    var u = $('.chat_box_user');

    u.live('click', function(){
        var cur_id = $(this).attr('id');
        if($(this).hasClass('active_chat') == false){

            $('.chat_box_user').removeClass('active_chat');
            $(this).addClass('active_chat');
            if( $('.message_user_list').filter('#'+cur_id).get(0) ){
                $('.message_user_list').hide();
                $('.message_user_list').filter('#'+cur_id).fadeIn(300);
                $('.right_column').find('.viewport').tinyscrollbar_update('bottom');
            }else{
                $('.message_user_list').hide();
                $('.right_column').find('.overview').append('<div class="message_user_list" id="' + cur_id + '"></div>');
            }
        }
        chat.new_message_event('clear', {id:cur_id});
    });
}
chat.new_message_event = function(act, ob){ // new, clear || obj

    var us_box_ev = $('.chat_box_user').filter('#'+ob.id);

    if(act == 'new'){
        if( us_box_ev.find('i').get(0) ){
            us_box_ev.find('i').text( parseInt( us_box_ev.find('i').text() ) + 1 );
        }else{
            us_box_ev.append("<i class='events_bubble_red'>1</i>");
        }
    }
    if(act == 'clear'){
        us_box_ev.find('i').remove();
    }
    var all_new_mess_count = 0;
    $('.chat_box_user').parent().find('i').each(function(){
        all_new_mess_count = parseInt( all_new_mess_count ) + parseInt( $(this).text() );
    });
    if(all_new_mess_count <= 0){
        chat.this.parent().find('i').hide();
    }else{
        chat.this.parent().find('i').text(all_new_mess_count).show();
    }
}

chat.get_current_chat = function(){
    var gcch = {
        id: $('.left_column').find('.active_chat').attr('id'),
        user_box: $('.left_column').find('.active_chat'),
        messages_box: $('.message_user_list').filter('#'+$('.left_column').find('.active_chat').attr('id'))
    };
    return gcch;
}
chat.get_current_user = function(id){
    $.each(users, function(i, n){
        if(n.attributes.id == id ){
            chat.user = n;
        }
    });
}
chat.create_message = function(sel_action, obj){
    if(sel_action == 'my_form_event_start'){
        var inp = $('#chat_message_input');
        var inpSbm = $('#chat_message_submit');
        var us = chat.user.attributes;

        inpSbm.parent().submit(function(){
            if( inp.length > 0 && $('.message_user_list:visible').get(0)){
                CH.trigger('chat_message', {
                    id: us.id,
                    name: us.email,
                    img: us.photo_path_thumb,
                    message: inp.val()
                })

                $('.message_user_list:visible').append(
                    '<div class="message_box me">' +
                      '<div class="img_box">' +
                        '<img alt="' + us.name + '" height="40" src="' + us.photo_path_thumb + '" width="40">' +
                      '</div>' +
                      '<div class="message_box_text">' +
                        inp.val() +
                      '</div>' +
                    '</div>'
                );
                inp.val('');
                $('.right_column').find('.viewport').tinyscrollbar_update('bottom');
            }
            return false;
        })
    }
    if(sel_action == 'theirs'){
        if(obj.id != uid){
            var mul = $('.message_user_list').filter('#'+obj.id);
            if(mul.get(0)){
                mul.append(
                    '<div class="message_box theirs ">' +
                      '<div class="img_box">' +
                        '<img alt="' + obj.name + '" height="40" src="' + obj.img + '" width="40">' +
                      '</div>' +
                      '<div class="message_box_text">' +
                        obj.message +
                      '</div>' +
                    '</div>'
                );
            }else{
                $('.right_column').find('.overview').append('<div class="message_user_list" style="display: none;" id="' + obj.id + '"></div>');
                mul = $('.message_user_list').filter('#'+obj.id);
                mul.append(
                    '<div class="message_box theirs ">' +
                      '<div class="img_box">' +
                        '<img alt="' + obj.name + '" height="40" src="' + obj.img + '" width="40">' +
                      '</div>' +
                      '<div class="message_box_text">' +
                        obj.message +
                      '</div>' +
                    '</div>'
                );
                $('.right_column').find('.head_name').find('p').html(obj.name);
                if(!$('.left_column').find('.chat_box_user#'+obj.id).get(0)){
                    chat.user_list_create(obj.id);
                }
            }
            $.gritter.add({
                title: 'Новое сообщение от ' + obj.name,
                image: obj.img,
                text: obj.message,
                after_open: function(e){
                    e.find('.gritter-item').live('click', function(ee){
                        if( $(ee.target).hasClass('gritter-close') == false){
                            $('.chat_block').show();
                            chat.this.parent().addClass('active_chat');
                            $('.chat_box_user').filter('#'+obj.id).trigger('click');
                            e.find('.gritter-close').trigger('click');
                        }

                    });
                }
              });

            $('.right_column').find('.viewport').tinyscrollbar_update('bottom');
            chat.new_message_event('new', obj);
        }
    }
}
chat.updateScroll = function(){
    $('.left_column').find('.viewport').tinyscrollbar_update();
    $('.right_column').find('.viewport').tinyscrollbar_update('bottom');
}
chat.save_state = function(){

}
chat.close = function(){
    $('.chat_close').bind('click', function(){
        $('.init_chat_link').trigger('click');
    });
}
chat.contacts_list_create = function(){
    var cont = $('.all_contacts');
    var contact = $('<div class="contacnt_list_user"></div>');
    $.each(users, function(i,n){
        cont.append(
            '<div class="contacnt_list_user" id="' + n.attributes.id + '">' +
                '<div class="img_box">' +
                    '<img alt="' + n.attributes.email + '" height="40" src="' + n.attributes.photo_path_thumb + '" width="40">' +
                '</div>' +
                '<div class="name">' +
                    n.attributes.email +
                '</div>' +
            '</div>'
        );
    });
    chat.contacts_list_click();
    $('.right_column').find('.viewport').tinyscrollbar_update();
}
chat.contacts_list_click = function(){
    var cluc = $('.contacnt_list_user');
    cluc.bind('click', function(){
        chat.user_list_create($(this).attr('id'));
    });
}
chat.contacts_list_show = function(act){
    if ( act == 'show' || act == 'show/hide' ) {
        if ( $('.all_contacts_btn').hasClass('show') == false ) {
            $('.all_contacts_btn').addClass('show');
            $('.message_user_list').hide();
            $('.all_contacts').fadeIn(200);
            $('.right_column').find('.viewport').tinyscrollbar_update('bottom');
            return false;
        }
    }
    if ( act == 'hide' || act == 'show/hide' ) {
        if ( $('.all_contacts_btn').hasClass('show') == true ) {
            $('.all_contacts_btn').removeClass('show');
            $('.message_user_list').hide();
            $('.all_contacts').hide();
            return false;
        }
    }
}
chat.init = function(th, users){

    $('.left_column').find('.viewport').tinyscrollbar();
    $('.right_column').find('.viewport').tinyscrollbar();
    if(th == 'start'){
        //alert('loool');
        window.users = users;
        chat.get_current_user(uid);
        chat.this = $('.init_chat_link');
        chat.this.parent().addClass('chat_work');
        chat.contacts_list_create();
        chat.users_list_click();
        chat.create_message('my_form_event_start');

        CH.bind("chat_message", function (data){
            chat.create_message('theirs', data);
        });
        chat.save_state();
        chat.close();
    }else{
        chat.this = $(th);
        if( chat.this.parent().hasClass('active_chat') == true){
            $('.chat_block').hide();
            chat.this.parent().removeClass('active_chat');
        }else{
            $('.chat_block').show();
            chat.this.parent().addClass('active_chat');

        }
    }
    return false;
}



