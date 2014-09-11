class MartinisController < ApplicationController

    def index
        render text: "Hello, martinis!"
    end

    def show
        render text: "Hello, martini."
    end
end
