module ApplicationHelper

  def show_pages_for(set)
    if set.size == 0
      t('pages.zero')
    elsif set.total_pages == 1
      t('pages.one')
    else
      t('pages.other', current: set.current_page,
        total: set.total_pages)
    end
  end
end
