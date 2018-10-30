class NewestController < ApplicationController
    def index
        @news = News.all
    end
end
