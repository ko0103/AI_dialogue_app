class HomesController < ApplicationController
  def index
    @theme = [ "環境問題", "AIの役割", "プログラミングの極意" ]
  end
end
