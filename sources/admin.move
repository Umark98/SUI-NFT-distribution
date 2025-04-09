module souv::souv_nft {

    use std::string:: String; 

    /// SOUV NFT structure
    public struct SOUV has key, store {
        id: UID,
        event: address,
        event_name: vector<String>,   
        attendee: address,
    }

    
    public struct Event has key, store {
        id: UID,
        name: vector<String>,         
    }

    /// Register and share a new event
    public entry fun register_event(event_name: vector<String>, ctx: &mut TxContext) {
        let event = Event {
            id: object::new(ctx),
            name: event_name,        
        };
        transfer::share_object(event);
    }

    
    public entry fun mint_and_transfer_souv(
        event: &Event,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let souv = SOUV {
            id: object::new(ctx),
            event: object::id_to_address(&object::id(event)),
            event_name: event.name,   
            attendee: recipient,
        };
        transfer::public_transfer(souv, recipient);
    }

    
    public entry fun claim_souv(souv: SOUV, recipient: address) {
        transfer::public_transfer(souv, recipient);
    }
}