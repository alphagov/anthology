module FiltersHelper
  def filter_link(text, filter, value)
    selected = current_scopes[filter] == value
    selected_class = selected ? "selected" : ""

    options = current_scopes.merge(filter => value)

    link_to text, books_path(options), class: selected_class
  end
end
