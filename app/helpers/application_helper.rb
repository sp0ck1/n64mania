module ApplicationHelper

  def class_names_selected_check(controller, action, href_path)
    class_names = "nav-links"
    class_names_selected = "nav-links selected"

    case href_path
      when "/games/unplayed"
        class_names = (controller == "games" && action == "unplayed") ? class_names_selected : class_names
      when "/games"
        class_names = (controller == "games" && action == "index") ? class_names_selected : class_names
      when "/players"
        class_names = (controller == "players" && action == "index") ? class_names_selected : class_names
      when "/races"
        class_names = (controller == "races" && action == "index") ? class_names_selected : class_names
      else "nav-links"
    end
    
    class_names
  end
end
