CREATE OR REPLACE FUNCTION check_user_block_request() RETURNS TRIGGER AS $$
DECLARE
    user_location POINT;
    block_center POINT;
    distance FLOAT;
    is_member BOOLEAN;
BEGIN
	-- Check if the user is already a member of the block
    SELECT IsJoined INTO is_member FROM UserBlocks WHERE UserID = NEW.SenderID AND BlockID = NEW.BlockID;
    IF is_member THEN
        RAISE EXCEPTION 'User is already a member of the block.';
    END IF;

    -- Get the user's location
    SELECT POINT(Latitude, Longitude) INTO user_location FROM Users WHERE UserID = NEW.SenderID;

    -- Get the block's center and radius
    SELECT POINT(CenterLatitude, CenterLongitude) INTO block_center FROM Blocks WHERE BlockID = NEW.BlockID;

    -- Calculate the distance between the user's location and the block's center
    distance = POINT(user_location) <-> POINT(block_center);

    -- Check if the user is within the block's radius
    IF distance > (SELECT Radius FROM Blocks WHERE BlockID = NEW.BlockID) THEN
        RAISE EXCEPTION 'User does not live within the block.';
    END IF;

    -- All checks passed
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER block_request_trigger
BEFORE INSERT ON BlockRequests
FOR EACH ROW
EXECUTE PROCEDURE check_user_block_request();
