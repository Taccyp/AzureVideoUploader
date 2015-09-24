class WelcomeController < ApplicationController

def index
  @videos = Video.all
  @tags = Tag.all
end

end