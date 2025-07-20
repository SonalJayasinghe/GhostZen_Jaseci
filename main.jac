import from mtllm.llm { Model }


glob llm = Model(model_name="gpt-4o");


"""Role: Think as a professional character provider.
1. User will ask to return a character.
2. You know about all of the movies in the world. Also you know about all the famous characters in the world.
3. First randomly select what you are proceed with; famous movies or famous characters in the world.
4. if its movies, find a random movie. Then find another random movie other than that. Make sure to select a random one. Always select a  famous movie. then find a character in that movie and return.
5. if you proceed with famous characters, find a random famous character and return that name.
"""
def get_random_character()  -> str byllm();


"""
Your a akinator game agent.
user will ask a question or guess the character via guess_or_question.
if the guess is correct return character_name_guessed as True.
if guess is wrong provide a hint about the character. But never mention the character name in the hint.
"""
def answer_question(
    character_to_be_guessed: str,
    guess_or_question: str
) -> QuestionResponse byllm();


obj QuestionResponse {
    has character_name_guessed: bool;
    has message: str;
}


node User {
    has userName: str;
    has games_played: int = 0;
    has games_won: int = 0;
    has score: int = 0;
}


node Game {
    has character: str;
    has completed: bool = False;
    has max_attempts: int = 10;
    has current_attempt: int = 0;
    has won: bool = False;
}


node Turn {
    has guess_or_question: str;
    has attempt_no: int;
    has response: QuestionResponse;
}


node Leaderboard {
    has users: list[UserResult] = [];
}


def create_or_get_leaderboard()  -> Leaderboard {
    leaderboardQuery = [root-->( ` ? Leaderboard ) ];
    if leaderboardQuery {
        return leaderboardQuery[0];
    } else {
        return (root ++> Leaderboard())[0];
    }
}


walker ShowLeaderboard {
    obj __specs__ {
        static has auth: bool = False;
    }

    can show_leaderboard with `root entry {
        leaderboard = create_or_get_leaderboard();
        report {"users" : leaderboard.users , } ;
    }
}


walker PlayGame {
    has userName: str;
    has guess_or_question: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can play_game with `root entry {
        user = self.create_or_get_user();
        activeGame = self.find_or_create_active_game(user);
        turn = self.create_turn(activeGame);
        print("turn", activeGame.character);
        if activeGame.won {
            report
            {"userName" : self.userName , "message" : "You successfully guessed" } ;
        } else {
            report
            {"userName" : self.userName , "message" : "Your guess was in correct" , "attempts_left" : (activeGame.max_attempts - activeGame.current_attempt) , "hint" : turn.response.message , } ;
        }
    }

    def create_or_get_user -> User {
        print("All users before");
        print("all users", [root-->( ` ? User ) ]);
        userQuery = [root-->( ` ? User : userName == self.userName ) ];
        if userQuery {
            return userQuery[0];
        } else {
            return (root ++> User(userName=self.userName))[0];
        }
    }

    def find_or_create_active_game(user: User) -> Game {
        gameQuery = [user-->( ` ? Game : completed == False ) ];
        if gameQuery {
            print(gameQuery);
            return gameQuery[0];
        } else {
            character = get_random_character();
            print("random character ", character);
            return (user ++> Game(character=character))[0];
        }
    }

    def create_turn(game: Game) -> Turn {
        game.current_attempt += 1;
        print(game.character, self.guess_or_question);
        response =
            answer_question(
                character_to_be_guessed=game.character,
                guess_or_question=self.guess_or_question
            );
        if response.character_name_guessed {
            game.won = True;
            game.completed = True;
        }
        if (game.current_attempt == game.max_attempts) {
            game.completed = True;
        }
        if game.completed {
            score = 100 * (game.max_attempts - game.current_attempt - 1);
            UpdatePlayerResult(won_game=game.won, score=score) spawn game;
        }
        return (game ++> Turn(
            guess_or_question=self.guess_or_question,
            attempt_no=game.current_attempt,
            response=response,

        ))[0];
    }
}


walker UpdatePlayerResult {
    has won_game: bool;
    has score: int;

    can find_user with Game entry {
        user = [here<--( ` ? User ) ][0];
        visit user;
    }

    can find_result with User entry {
        here.games_played += 1;
        here.score += self.score;
        if self.won_game {
            here.games_won += 1;
        }
        self.update_leaderboard(here);
    }

    def update_leaderboard(user: User) {
        leaderboard = create_or_get_leaderboard();
        leaderboard.users =
            [ x for x in leaderboard.users if x.userName != user.userName ];
        leaderboard.users.append(UserResult(userName=user.userName, score=user.score));
        leaderboard.users = sorted(leaderboard.users, key=sortKey);
        leaderboard.users = leaderboard.users[ 0 : 5 ];
    }
}


def sortKey(user: UserResult) {
    return user.score;
}
