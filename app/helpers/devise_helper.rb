module DeviseHelper
  def devise_error_messages!
    return '' unless devise_error_messages?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = 'Looks like something went wrong'

    html = <<-HTML
    <div id='error_explanation'>
      <h2>#{sentence}</h2>
      <ul class='devise_alert'>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
