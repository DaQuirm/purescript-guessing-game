exports.question = function(readline) {
	return function (query) {
		return function(callback) {
			return function() {
				readline.question(query, function (answer) {
					callback(answer)();
				});
			};
		};
	};
};
