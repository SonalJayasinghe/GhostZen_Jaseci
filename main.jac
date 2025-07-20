import from mtllm.llm {Model}

glob llm = Model(model_name="gpt-4o-mini");

 """Provide a random popular character's name. Dont go for too common characters. Dont go for too rare characters."""
def get_random_character()  -> str byllm();


"""User is guessing or asking a question about the character. If guess is incorrect, return a funny hint that is not obvious in the response but dont mention the character in the response. User has to guess the character name."""
def answer_question(
    character_to_be_guessed: str, question_or_guess: str
) -> QuestionResponse byllm();


obj QuestionResponse {
    has character_name_guessed: bool;
    has response: str;
}

node User { 
    has userName: str;

}

node Game {
    has character:str;
    has completed: bool;
    has max_attempts: int = 10;
    has current_attempt : int = 0;
    has won: bool = False;
}

node Turn {
    has guess_or_question: str;
    has attempt_no: int;
}

walker PlayGame {
    has userName: str;
    has guess_or_question: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can play_game with `root entry {
        user = self.create_or_get_user();
        print(user);

        activeGame = self.find_or_create_active_game(user);
        self.create_turn(activeGame);
        report {"userName": self.userName};
    }

    def create_or_get_user -> User {
        userQuery = [root-->(`?User: userName==self.userName)];
        if userQuery  {
            return userQuery[0];
        } else {
            return (root++> User(userName=self.userName))[0];
        }
    }

    def find_or_create_active_game(user: User) -> Game {
        gameQuery = [user-->(`?Game: completed==False)];
        character = get_random_character();
        if gameQuery {
            return gameQuery[0];
        } else {
            return (user ++> Game(character=character, completed=False))[0];
        }
    }

    def create_turn(game : Game) -> Turn {
       game.current_attempt += 1;

       game ++> Turn (
        guess_or_question=self.guess_or_question,
        attempt_no=game.current_attempt
       );

    }
}

with entry {
    PlayGame(userName="Sonal", guess_or_question="Is he a fictional character ? ") spawn root;
    # PlayGame(userName="Sonal", guess_or_question="Is he a male ? ") spawn root; 
}






