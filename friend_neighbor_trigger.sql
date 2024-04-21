CREATE OR REPLACE FUNCTION check_friend() RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS(SELECT 1 FROM FriendRequests WHERE SenderID = new.SenderID AND ReceiverID = new.ReceiverID) then
		RAISE EXCEPTION 'Request Failed: Request already sent';
		return NULL;
	ELSIF EXISTS(SELECT 1 FROM UserFriends WHERE (UserID1 = new.SenderID AND UserID2 = new.ReceiverID) 
				 OR (UserID1 = new.ReceiverID AND UserID2 = new.SenderID)) then
		RAISE EXCEPTION 'Request Failed: User is friend';
		return NULL;
	ELSE
		return new;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_friend_trigger BEFORE INSERT ON FriendRequests
FOR EACH ROW
EXECUTE FUNCTION check_friend();
