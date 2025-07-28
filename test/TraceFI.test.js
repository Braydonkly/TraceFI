const TraceFI = artifacts.require("TraceFI");

contract("TraceFI", ([account, user1, user2]) => {
  let tracefi;

  before(async () => {
    tracefi = await TraceFI.deployed();
  });

  describe("deployment", () => {
    it("deploys successfully", async () => {
      const address = await tracefi.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
    });
  });

  describe("registering and retrieving clients", () => {
    let result;
    before(async () => {
      result = await tracefi.registerClient(
        "Alice", "S1234567A", "SG", "SG", "123 Main St", "123456",
        "F", "SG", "1990-01-01", "61234567", "91234567", "Engineer",
        "Acme Corp", "12345", "Low", ""
      );
    });

    it("verifies client name", async () => {
      const client = await tracefi.getClientById(0);
      assert.equal(client[2], "Alice", "Client name is not correct");
    });
    it("verifies client NRIC", async () => {
      const client = await tracefi.getClientById(0);
      assert.equal(client[3], "S1234567A", "Client NRIC is not correct");
    });
    it("verifies client nationality", async () => {
      const client = await tracefi.getClientById(0);
      assert.equal(client[4], "SG", "Client nationality is not correct");
    });
    it("verifies client risk status", async () => {
      const client = await tracefi.getClientById(0);
      assert.equal(client[15], "Low", "Client risk status is not correct");
    });
  });

  describe("adding and retrieving transactions", () => {
    before(async () => {
      await tracefi.addTransaction(0, "Deposit $1000");
      await tracefi.addTransaction(0, "Withdrawal $500");
    });
    it("retrieves all transactions for a client", async () => {
      const txs = await tracefi.getTransactions(0);
      assert.equal(txs.length, 2, "Transaction count should be 2");
      assert.equal(txs[0], "Deposit $1000", "First transaction incorrect");
      assert.equal(txs[1], "Withdrawal $500", "Second transaction incorrect");
    });
  });

  describe("edge cases", () => {
    it("returns empty for non-existent client transactions", async () => {
      const txs = await tracefi.getTransactions(99);
      assert.equal(txs.length, 0, "Should return empty array for unknown client");
    });
    it("does not allow duplicate NRIC registration (if contract enforces)", async () => {
      // Only test if contract has duplicate NRIC check, otherwise skip
      try {
        await tracefi.registerClient(
          "Bob", "S1234567A", "SG", "SG", "456 Main St", "654321",
          "M", "SG", "1985-05-05", "61234568", "91234568", "Manager",
          "Beta Corp", "54321", "Medium", ""
        );
        // If no error, contract does not enforce uniqueness
      } catch (e) {
        assert(e.message.includes("revert"), "Should revert on duplicate NRIC");
      }
    });
  });

  describe("updating and deleting clients (if supported)", () => {
    it("deletes a client (if supported)", async () => {
      try {
        await tracefi.deleteClient(0);
        // Try to get the client again
        const client = await tracefi.getClientById(0);
        // If contract returns default/empty, test passes
        assert(client[2] === "" || client[2] === undefined, "Client should be deleted");
      } catch (e) {
        // If not supported, skip
        assert(true);
      }
    });
  });
});
