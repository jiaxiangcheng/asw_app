class NewestController < ApplicationController
    def index
        @submissions = Submission.all.order("created_at DESC")
    end
end
