#coding: utf-8
Facestat.controllers :stats do
  get :index, :map => '/' do
    render 'stats/index'    
  end

  get :groups do
    url = "https://graph.facebook.com/me/groups?access_token=#{session[:auth_token]}"
    body = HTTParty.get(url).body
    @groups = MultiJson.decode(body).first[1]

    render 'stats/table', :layout => false
  end

  get :group, :with => :id do
    gid = params[:id]
    url = "https://graph.facebook.com/#{gid}/feed?access_token=#{session[:auth_token]}"
    body = HTTParty.get(url).body
    all = MultiJson.decode(body)
    group = all.first[1]

    @actions = []
    group.each do |post|
      author = post['from'] rescue (logger.error post.inspect)
      @actions << {
        :action => 'topic',
        :author_id => author['id'],
        :author => author['name'],
        :topic => (post['message'] || post['description'] || '')[0..50],
        :message => '',
        :link => post['actions'][0]['link'].gsub(/.com/, '.com/groups'),
        :time => post['created_time']
      }
      comments = post['comments'].first[1]
      comments.each do |comment|
        author = comment['from']
        @actions << {
          :action => 'comment',
          :author_id => author['id'],
          :author => author['name'],
          :message => (comment['message'] || '')[0..50],
          :link => post['actions'][0]['link'].gsub(/.com/, '.com/groups'),
          :topic => (post['message'] || post['description'] || '')[0..50],
          :time => comment['created_time']
        }
      end unless comments == 0
    end
    render 'stats/group', :layout => false
  end 
end

