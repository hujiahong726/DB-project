-- CREATE OR REPLACE FUNCTION check_friend() RETURNS TRIGGER AS $$
-- BEGIN
-- 	IF EXISTS(SELECT 1 FROM FriendRequests WHERE SenderID = new.SenderID AND ReceiverID = new.ReceiverID) then
-- 		RAISE EXCEPTION 'Request Failed: Request already sent';
-- 		return NULL;
-- 	ELSIF EXISTS(SELECT 1 FROM UserFriends WHERE (UserID1 = new.SenderID AND UserID2 = new.ReceiverID) 
-- 				 OR (UserID1 = new.ReceiverID AND UserID2 = new.SenderID)) then
-- 		RAISE EXCEPTION 'Request Failed: User is friend';
-- 		return NULL;
-- 	ELSE
-- 		return new;
-- 	END IF;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER check_friend_trigger BEFORE INSERT ON FriendRequests
-- FOR EACH ROW
-- EXECUTE FUNCTION check_friend();


CREATE OR REPLACE FUNCTION check_same_block() RETURNS TRIGGER 
	LANGUAGE plpgsql VOLATILE
    AS
	$BODY$
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM UserBlocks AS ub1
			JOIN UserBlocks AS ub2 ON ub1.BlockID = ub2.BlockID
			WHERE ub1.UserID = NEW.UserID1 AND ub2.UserID = NEW.UserID2 AND ub1.IsJoined = TRUE AND ub2.IsJoined = TRUE
		) THEN
			RAISE EXCEPTION 'Users must be in the same block to be neighbors.';
		END IF;
		RETURN NEW;
	END;
	$BODY$;
CREATE TRIGGER check_neighbor_same_block BEFORE INSERT ON userneighbors
FOR EACH ROW
EXECUTE FUNCTION check_same_block();

