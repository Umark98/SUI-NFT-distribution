module souv::admin {
    

    public struct Admin has key {
        id: UID,
        owner: address,
    }

    public fun create_admin(ctx: &mut TxContext) {
        let admin = Admin {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
        };
        transfer::transfer(admin, tx_context::sender(ctx));
    }

    public fun assert_is_admin(admin: &Admin, ctx: &TxContext) {
        assert!(admin.owner == tx_context::sender(ctx), 1);
    }

    
}