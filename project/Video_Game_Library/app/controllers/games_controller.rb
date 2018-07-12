class GamesController < ApplicationController
    before_action :require_login

    def new
        @game = Game.new(user_id: params[:user_id], console_id: params[:console_id])
    end

    def create
        @user = User.find_by(id: session[:user_id])
        @game = Game.new(game_params)
        if flash[:message]
            flash[:message].clear
        elsif @game.save
            redirect_to user_consoles_path(@user)
        else
            flash[:message] = "Please fill out all fields"
            render :new
        end
    end

    def edit
        @user = User.find_by(id: session[:user_id])
        @console = Console.find_by(id: params[:console_id])
        @game = Game.find(params[:id])
    end

    def update
        @user = User.find_by(id: session[:user_id])
        @game = Game.find(params[:id])
        @game.assign_attributes(game_params)
        if @game.save
            redirect_to user_consoles_path(@user)
        else
            render :edit
        end
    end

    def destroy
        Game.find(params[:id]).destroy
        @user = User.find_by(id: session[:user_id])
        redirect_to user_consoles_path(@user)
    end

    private

    def game_params
        params.require(:game).permit(:title, :user_id, :console_id)
    end

    def require_login
        return head(:forbidden) unless session.include? :user_id
    end

end
