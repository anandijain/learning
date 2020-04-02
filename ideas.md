# ideas

## purely random


## list

1. (Noria)[https://www.youtube.com/watch?v=kiMUI0y91YI] https://www.youtube.com/watch?v=kiMUI0y91YI Databases and Message Passing
    * In your paper, it is stated that state size is determined by 95% read latency
    * Ik that ML isn't really at the level where this could be viable, but I'm wondering if an RL agent or ML program could maximize p(in_cache) or time(to_response) given some context, the last n queries, for example.
    * Optimizing time to response, (or time to response of expected queries) is exciting to me, because I'm imagining interesting/creative techniques for exploiting locality, typically instances where hand tuned algorithms are unstable.
    * I'm wondering if undesirable thrashing could arise from periodicity in the queries made to the DB. I'm imagining a multi-armed bandit problem, where the 95%ile is a potentially less optimal metric.
	* Lastly, I'm interested in this type of dynamic optimization in multi-server domains, where interesting pathings can take hold, such as the emergent cooperative caching of data. for instance, if it is likely that there will be a bunch of requests from locA, but the server at A, is handling a bunch of other stuff. Depending on the bottleneck, whether network, memory, etc, other nodes will be prompted to 'help out' so to speak.
	* I'm hoping that this can provide a superlinear time complexity to n-server Noria.
	* btw im an undergrad so ignore me
	* another paradox is the lack of counterfactual knowledge for consistent state distribution. 
	* is it possible to have each node have the ability (used in the updating of weights and biases for reducing time to response) to probabilistically send messages throughout the network, where nodes can decide to listen/take the message into account.
	* from this it is possible for complex nash equillibria to be found, maybe??
	* 
