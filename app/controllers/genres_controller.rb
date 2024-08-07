class GenresController < ApplicationController
  before_action :set_genre, only: %i[ show edit update destroy ]

  # GET /genres or /genres.json
  def index
    @genres = Genre.all.sort_by {|n| n.name }
  end

  # GET /genres/1 or /genres/1.json
  def show
    @genre = Genre.find(params[:id])
    @page_title = "N64Mania: #{@genre.name} Genre"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_genre
      @genre = Genre.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def genre_params
      params.fetch(:genre, {})
    end
end
