Facestat.controllers :auth do
  get :facebook do
    token = params[:token]
    uid = params[:uid]

    user = MultiJson.decode HTTParty.get("https://graph.facebook.com/me?access_token=#{token}").body

    session[:uid] = uid 
    session[:auth_token] = token
   
    user['name']
  end
end

