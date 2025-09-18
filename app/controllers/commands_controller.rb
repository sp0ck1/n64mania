class CommandsController < ApplicationController  
  protect_from_forgery with: :null_session
  
  def index
  end

  def show
  end
  
  def serve
    comm = Command.find_by_command(params[:command])
    if !comm.nil?
      date = comm.created_at
      day = date.day
      month = date.strftime("%B")
      year = date.year
      date_s = "#{month} #{day}, #{year}"

      command = {
        :command  =>  comm.command,
        :text     =>  comm.text,
        :author   =>  comm.author,
        :created  =>  date_s
      }
    end
    render json: command
  end

  def add

    Rails.logger.debug "Received params: #{params.inspect}"

    author = params[:author]
    command_name = params[:command]
    text = params[:text]
 
    ActiveRecord::Base.transaction do
      command = Command.new(author: author, command: command_name, text: text)
      
      if command.save
        render plain: "Command added!"
      else 
        Rails.logger.debug "Validation errors: #{command.errors.full_messages}"
        render plain: "Failed to save command", status: :unprocessable_entity
    end
  end
  
end