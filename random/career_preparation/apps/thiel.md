# What are you working on now? *

I'm working on building a model and data driven hedge fund specializing in the sports wagering market. 
I work as the tech-lead with two other UChicago students, Ethan Abraham and Ben Broner.
Two technical tasks crucial to our success that I have made progress on are: 1) building a robust and real time database and 2) building a suite of comprehensive models.

I have built a live data-scraper that is deployed on google cloud to track the odds of a variety of sports (see github anandijain/sips).
This Python package also has the tools to scrape the major sports-reference websites for the history of all players, teams, games, etc.
Managing and organizing this data into a unified database is an unsolved challenge.

On the modeling side, I have built LSTM networks for odds predictions using TensorFlow and PyTorch, which from the training logs clearly overfits as: lim(epochs->inf) : test_loss -> inf ^ train_loss-> >0. 
This is a problem that I expected and demonstrates the weakness of our current models: there is a significant lack of data, not only in the quantity, but the number of features and parameters tracked. The quantity problem partially improves as we continually are getting new data, however, we need to collect much more.
This can be solved by scaling up our data collection pipelines to track more sportsbooks, sentiment (news, twitter, etc), and using computer vision to analyze team formations and player posture/joint dynamics.

I am looking into using Go-lang with fast-http for a new data ingestion pipeline to track more odds books and markets with lower latency, multi-server load-balancing, and asynchronous requesting. Async requests hasn't worked in Python as the site quickly rate-limits me, however, I can get around this by making use of multiple servers with different IP addresses. 

Another interesting modeling tool I've played around with is DifferentialEquations.jl (anandijain/Sips.jl).
I can get a basic neural differential equation to learn the ODE of the odds over time, however, speed limitations makes this currently infeasible as a viable tool.
Lastly, I have built a basic Gym reinforcement learning environment to test whether RL is a viable option for risk-mitigated betting (anandijain/gym-sips). The DQN that I implemented did not seem to learn the long term dependencies that I had hoped for, but I want to try some different algorithms and models. I am confident that with more time, I can built a much better tech-stack.

I am also very interested in applying quantitative sports science and medicine to use computer vision to start doing more fundamental analysis of sport and skill.
Eventually I foresee needing on-site inferencing chips to have a competitive advantage in a market that is underdeveloped. I’d like to use the RISC-V ISA to do this.

I am inspired by this challenge because I think that it is a market that hasn't been thought of in the same league as quantitative finance, however, I see no reason why it isn't.
I'd like to prove this.


# What cool stuff have you worked on in the past?

I spent most of my time making music in high school and the first year of college.
I 