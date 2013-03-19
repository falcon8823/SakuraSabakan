module ApplicationHelper

  # bootstrapのアイコン表示タグ
  def icon_tag(klass)
    content_tag :i, '', class: klass
  end

end
