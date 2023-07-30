module ApplicationHelper

  def class_names_selected_check(controller, action, href_path)
    class_names = "nav-links"
    class_names_selected = "nav-links selected"

    class_names = case href_path
      when "/games/unplayed"
        class_names_selected if controller == "games" && action == "unplayed"
      when "/games"
        class_names_selected if controller == "games" && action == "index"
      when "/players"
        class_names_selected if controller == "players" && action == "index"
      when "/races"
        class_names_selected if controller == "races" && action == "index"
         
    end
  end
end
