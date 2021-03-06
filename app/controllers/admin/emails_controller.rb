class Admin::EmailsController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'
  expose(:shop){ current_user.shop }
  expose(:users){ shop.users }
  expose(:emails){ shop.emails }
  expose(:email)
  expose(:subscribes){ shop.subscribes }
  expose(:subscribe)

  def index
  end

  def update
    email.save
    redirect_to notifications_path , notice: notice_msg
  end

  def follow
    sub = params[:subscribe_type]
    address = params[:address]
    if sub == 'email'
      subscribe.address = address
      unless subscribe.save
        flash[:error] = subscribe.errors.full_messages[0]
        render template: "shared/error_msg"
        return
      end
    else
      subscribe.user_id = sub
      subscribe.save
    end
  end

  def unfollow
    subscribe.destroy
  end

  def preview
    @subject = Liquid::Template.parse(params[:email][:title]).render(KeyValues::DemoData.first.attributes[:order_1])
    if params[:view_type] == 'text'
      @body = Liquid::Template.parse(params[:email][:body]).render(KeyValues::DemoData.first.attributes[:order_1])
    else
      @body = Liquid::Template.parse(params[:email][:body_html]).render(KeyValues::DemoData.first.attributes[:order_1])
    end
    render action: 'preview',layout: false
  end

end
